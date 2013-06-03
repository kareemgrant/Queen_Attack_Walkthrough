class Queens

  attr_reader :white_pos, :black_pos

  def initialize(positions = {})
    @white_pos = positions.fetch(:white, [0,3])
    @black_pos = positions.fetch(:black, [7,3])
    check_positions
  end

  def white
    white_pos
  end

  def black
    black_pos
  end

  def check_positions
    raise ArgumentError if white_pos == black_pos
  end

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

  def attack?
    same_row_or_column? || same_diagonal?
  end

  def same_row_or_column?
    white_pos[0] == black_pos[0] || white_pos[1] == black_pos[1]
  end

  def same_diagonal?
    (white_pos[0] - black_pos[0]) == (white_pos[1] - black_pos[1])
  end

end
