class MountainBike
  attr_reader :cols, :rows, :mountain
  attr_accessor :max_path

  def initialize(map_path = './map.txt')
    @mountain = []
    @max_path = nil
    # Load map into 2d array
    File.open(map_path, "r") do |file|
      @cols, @rows = file.gets.split(' ').map(&:to_i)
      while line = file.gets do
        @mountain << line.split(' ').map(&:to_i)
      end
    end
  end

  def find_longest_path
    # North border of the mountain
    row = 0
    for col in 0..(cols - 1)
      path_for_point(row, col, [mountain[row][col]])
    end
    # South border of the mountain
    row = rows - 1
    for col in 0..(cols - 1)
      path_for_point(row, col, [mountain[row][col]])
    end
    # West border of the mountain
    col = 0
    for row in 1..(rows - 2) do
      path_for_point(row, col, [mountain[row][col]])
    end 
    # East border of the mountain
    col = cols - 1
    for row in 1..(rows - 2) do
      path_for_point(row, col, [mountain[row][col]])
    end
    # return length of max path
    max_path.to_a.length 
  end

  def ride
    if max_path
      # ride downhill through the max path
      max_path.reverse.join(' -> ')
    else
      puts "Find longest path first!"
    end
  end

  private

  def path_for_point(row, col, current)
    # get next possible steps
    [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]].each do |p|
      y, x = p
      # keep bike inside the mountain
      valid_point = x >= 0 && y >= 0 && x < cols && y < rows
      # next point value should be greater than current
      if valid_point && mountain[y][x] > mountain[row][col]
        # go to the next point
        cur = current.clone 
        cur << mountain[y][x]
        path_for_point(y, x, cur)
      end
    end
    # set max path if no possible steps
    set_max_path(current)
  end

  def set_max_path(current)
    self.max_path = current.clone if max_path.nil?
    # compare current and max paths, steepest path is preferable
    if (current.length > max_path.length) ||
       (current.length == max_path.length && (current.last - current.first) > (max_path.last - max_path.first)) 
      self.max_path = current.clone
    end
  end
end


