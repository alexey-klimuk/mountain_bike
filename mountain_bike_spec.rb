require_relative "mountain_bike"

describe MountainBike do
  let(:data) { "4 4\n4 8 7 3\n2 5 9 3\n6 3 2 5\n4 4 1 6" }
  
  before(:each) do
    allow(File).to receive(:open).and_yield(StringIO.new(data))
  end

  describe '#initialize' do    
    context 'with default file' do
      it 'should open default file' do
        expect(File).to receive(:open).with('./map.txt', 'r')
   	MountainBike.new	
      end
    end

    context 'with custom file' do
      it 'should open custom file' do
        file_path = "./map1.txt"
        expect(File).to receive(:open).with(file_path, 'r')
   	MountainBike.new(file_path)	
      end
    end

    it 'should get mountain size from file' do
      mb = MountainBike.new
      expect(mb.cols).to eq(4)
      expect(mb.rows).to eq(4)
    end

    it 'should get mountain size from file' do
      expect(MountainBike.new.mountain).to eq([[4,8,7,3], [2,5,9,3], [6,3,2,5], [4,4,1,6]])
    end

    it 'should set max path to nil' do
      expect(MountainBike.new.max_path).to be_nil
    end    
  end

  describe '#set_max_path' do
    it 'should set longest path as max' do
      mb = MountainBike.new
      mb.max_path = [1,2,3]
      new_max = [1,2,3,4]
      mb.send(:set_max_path, new_max)
      expect(mb.max_path).to eq(new_max)
    end

    it 'should set steepest path as max' do
      mb = MountainBike.new
      mb.max_path = [1,2,3]
      new_max = [1,2,4]
      mb.send(:set_max_path, new_max)
      expect(mb.max_path).to eq(new_max)
    end
  end

  describe '#find_longest_path' do
    it 'should solve simple test map' do
      mb = MountainBike.new
      expect(mb.find_longest_path).to eq(5)
      expect(mb.max_path).to eq([1,2,3,5,9])
    end

    it 'should call path_for_point method for border points' do
      mb = MountainBike.new
      expect(mb).to receive(:path_for_point).exactly((mb.cols + mb.rows - 2) * 2).times
      mb.find_longest_path
    end
  end

  describe '#ride' do
    context 'with max path' do
      it 'should ride max path' do
        mb = MountainBike.new
        mb.find_longest_path
        expect(mb.ride).to eq('9 -> 5 -> 3 -> 2 -> 1') 
      end 
    end

    context 'without max path' do
      it 'should ride max path' do
        mb = MountainBike.new
        expect(STDOUT).to receive(:puts).with('Find longest path first!')
        mb.ride
      end
    end
  end
end 
























