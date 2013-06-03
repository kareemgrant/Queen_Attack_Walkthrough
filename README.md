# Warmup Walkthrough: Queen Attack

Here at gSchool, we're given a warmup every morning (except Fridays) to start off the day. Here's a play-by-play of a recent warmup that I completed. 

#####The Instructions:

In the game of chess, a queen can attack pieces which are on the same row,
column, or diagonal.

A chessboard can be represented by an 8 by 8 array.

Write a program that positions two queens on a chess board and indicates
whether or not they are positioned so that they can attack each other.

```ruby
queens = Queens.new(:white => [2, 3], :black => [5, 6])
queens.to_s
	# => "O O O O O O O O
	
	
      O O O O O O O O
      O O O W O O O O
      O O O O O O O O
      O O O O O O O O
      O O O O O O B O
      O O O O O O O O
      O O O O O O O O"

queens.attack?
	# => true
```

###### Source
[J Dalbey's Programming Practice problems](http://users.csc.calpoly.edu/~jdalbey/103/Projects/ProgrammingPractice.html)

##### Provided Test Case

```ruby
class QueensTest < MiniTest::Unit::TestCase

  def test_default_positions
    queens = Queens.new
    assert_equal [0, 3], queens.white
    assert_equal [7, 3], queens.black
  end

  def test_specific_placement
    queens = Queens.new(white: [3, 7], black: [6, 1])
    assert_equal [3, 7], queens.white
    assert_equal [6, 1], queens.black
  end

  def test_cannot_occupy_same_space
    assert_raises ArgumentError do
      Queens.new(white: [2, 4], black: [2, 4])
    end
  end

  def test_string_representation
    queens = Queens.new(white: [2, 4], black: [6, 6])
    board = <<-BOARD.chomp
O O O O O O O O
O O O O O O O O
O O O O W O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O O O B O
O O O O O O O O
    BOARD
    puts queens.inspect
    assert_equal board, queens.to_s
  end

  def test_cannot_attack
    queens = Queens.new(white: [2, 3], black: [4, 7])
    assert !queens.attack?
  end

  def test_can_attack_on_same_row
    queens = Queens.new(white: [2, 4], black: [2, 7])
    assert queens.attack?
  end

  def test_can_attack_on_same_column
    queens = Queens.new(white: [5, 4], black: [2, 4])
    assert queens.attack?
  end

  def test_can_attack_on_diagonal
    queens = Queens.new(white: [1, 1], black: [6, 6])
    assert queens.attack?
  end

  def test_can_attack_on_other_diagonal
    queens = Queens.new(white: [0, 6], black: [1, 7])
    assert queens.attack?
  end

  def test_can_attack_on_yet_another_diagonal
    queens = Queens.new(white: [4, 1], black: [6, 3])
    assert queens.attack?
  end

end
```

#####My Approach:

The first thing I did was look at the test cases (which are provided with the warmups) for clues on how to approach the problem. 

The first test expects us to ensure that the default positions are adheared to. 

```ruby
  def test_default_positions
    queens = Queens.new
    assert_equal [0, 3], queens.white
    assert_equal [7, 3], queens.black
  end
```

`Queens.new` is a clear indication that new instances of Queens can be created without specifying any arguments. We also see that the default arguments take the form of a hash that includes two arrays. `queens.white` and `queens.black` also indicate that we are going to create two methods that have access to each of the arrays that are initialized with the Queens instance. We now have all the information we need to make the first test past. 

```ruby
  attr_reader :white_pos, :black_pos

  def initialize(positions = {})
    @white_pos = positions.fetch(:white, [0,3])
    @black_pos = positions.fetch(:black, [7,3])
  end

  def white
    white_pos
  end

  def black
    black_pos
  end

 ```
 
First I use 'fetch' to specify a default value of a hash. I picked this tip up from Sandi Metz's Practical Object Oriented Design in Ruby (I highly recommend it!). Next I create attr_reader methods to allow all of the methods in the class to have read access to the two arrays (@white_pos and @black_pos). I then create the methods the test is expected:

```ruby
   def white
    white_pos
  end

  def black
    black_pos
  end
```

I know what you're thinking, why did I create two additional methods when I could have easily made called my two instance methods @white and @black and have the attr_reader create the methods for me? Well, this was a design decision on my part. I like to have method names that are intuitive to the way I think. In this case, since the warmup involved evaluating the "placement" the queen pieces, I felt the method names of white_pos and black_pos where much more appropriate. 

Run the tests and they should pass. Viola!!

As luck would have it, the next test passes without much effort. 

```ruby
  def test_specific_placement
    queens = Queens.new(white: [3, 7], black: [6, 1])
    assert_equal [3, 7], queens.white
    assert_equal [6, 1], queens.black
  end
```
Here the new Queens instances are being instantiated with parameters. These parameters will simply override the existing results. Run the tests, and they should pass.

The following test clearly states that we sould raise an error if the positions of both the black and white queens are the same:

```ruby
  def test_cannot_occupy_same_space skip
    assert_raises ArgumentError do
      Queens.new(white: [2, 4], black: [2, 4])
    end
  end

```

Here I added a new method that will be solely responsible for checking for this case:

```ruby
  def check_positions
    raise ArgumentError if white_pos == black_pos
  end
```

Since this is a check that should happen immediately upon instance initialization, I placed the call to this method in `initialize`

```ruby
  def initialize(positions = {})
    @white_pos = positions.fetch(:white, [0,3])
    @black_pos = positions.fetch(:black, [7,3])
    check_positions
  end

```

All tests should be passing at this point. 

The next test was tricky:

```ruby
  def test_string_representation
    skip
    queens = Queens.new(white: [2, 4], black: [6, 6])
    board = <<-BOARD.chomp
O O O O O O O O
O O O O O O O O
O O O O W O O O
O O O O O O O O
O O O O O O O O
O O O O O O O O
O O O O O O B O
O O O O O O O O
    BOARD
    puts queens.inspect
    assert_equal board, queens.to_s
  end
```

This test calls upon us to create a to_s method that pretty prints a board with each of the queen pieces on it. I'll admit, this one had me stumped for a while. But I just couldn't stop thinking about it. I could create a method that printed out "0"s in the required format, but how was I supposed to know where in the sequence of strings to place the black and white queens????

So after toying around with different approaches, I asked Katrina Owens, one of our awesome instructors for a clue. She said that ranges were the key. So with that clue, I went back to the drawing board. After some non-stop tinkering, I finally understood what Katrina was talking about. The key to solving this particular problem is understanding that this board is an array of arrays - how else are we suppposed to know how where to place to pieces. So the next hurdle to overcome was to figure out how they went from an array of arrays to strings. That's when Katrina's clue came to mind - ranges. 

You can create arrays from ranges like this:

```ruby
(1..3).to_a

=> [1, 2, 3]
```
And since our board is an array of arrays with zero-based numbering scheme, we can create an 8 x 8 board by looping through two arays that have 8 elements each like so:

```ruby
board = ""
(0..7).to_a.each do |row|
	(0..7).to_each do |col|
		board << "0 "
	end
	"\n"
end
```

We have to add a new line to character after the inner loop completes it's interation for each row for formatting purposes. 

So now that we know how to create the board, our remaning task is to add logic that will place the the pieces in the correct position. Well, that part just got a lot easier now that we have a two-dimensional array. Since each element in each array represents the row and column respectively, we now have the equivalent of a coordinate system.  

With all that knowledge, here was my implemenation:


```ruby
  def to_s
    board = ""

    rows = (0..7).to_a
    cols = (0..7).to_a

    rows.each do |r|
      cols.each do |c|

        case [r, c]
        when white_pos
          input = "W "
        when black_pos
          input = "B "
        else
          input = "O "
        end
        board << input
      end
      board << "\n"
    end
    board
  end
```

Not pretty but this method prints out an 8 x 8 board and places the pieces in their correct position. And this "should pass" (more on that later). 

Let's take out the logic responsible for placing the queens in the their correct positions and stick them into their own method:

```ruby
  def place_queens(row, column)
    case [row, column]
    when white_pos
      input = "W "
    when black_pos
      input = "B "
    else
      input = "O "
    end
  end
```

With that move, our to_s method know looks much more manageable:

```ruby
  def to_s
    board = ""

    rows = (0..7).to_a
    cols = (0..7).to_a

    rows.each do |r|
      cols.each do |c|
        board << place_queens(r, c)
      end
      board << "\n"
    end
    board
  end
```

That's it for now, I'll detail my approach to making the remaining tests green in the near future. Who knew writing about code was so much fun!
