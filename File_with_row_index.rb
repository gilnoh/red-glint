

# this ruby class wraps File write access, 
# and generates one additional index file. 
class Filewrite_with_row_index 
  
  # filename 
  attr_reader :indexname
  attr_reader :data_f
  attr_reader :index_f  

  # always overwrite (if existing) the files   
  def initialize (filename)
    @indexname = filename + ".index" 
    @data_f = File.open(filename, "w")
    @index_f = File.open(@indexname, "w")    
    @cur_num = 0 
    @cur_pos = @data_f.pos # 0
  end

  def puts(string)
    update_index
    @data_f.puts(string)
    @cur_num += 1 
    @cur_pos = @data_f.pos 
  end
  
  private
  def update_index
    @index_f.puts("#{@cur_num}\t#{@cur_pos}")
  end
end


# this ruby class wraps File read access, 
# and does a fast retrieval of a specific line (row) 
# with one index file. 

class Fileread_with_row_index
  # filename 
  attr_reader :data_f
  attr_reader :row_pos_index 
  attr_reader :count_row

  # open file and index file read only, 
  # throw exception if can't open them. 
  def initialize (filename)
    @indexname = filename + ".index" 
    @data_f = File.open(filename)
    load_index 
  end

  # read row (line) with line number. 
  # note that the first line is "0" 
  def read_row(row_num)
    target_pos = @row_pos_index[row_num] 
    raise "no such row: #{row_num}" if (target_pos == nil)
    @data_f.seek(target_pos) 
    @data_f.readline.chop # return the row(line) without last \n
  end
  
  private 
  def load_index
    @row_pos_index = [] 
    @index_f = File.open(@indexname) 
    @index_f.each_line do |line|
      (row, pos) = line.split("\t")
      @row_pos_index[row.to_i] = pos.to_i 
    end
    @count_row = @row_pos_index.size()
  end
end

# this class provides a merger for multiple row-indexed files into one
# (bigger) row-indexed file. 
class Simple_merger
  def initialize(filenames_arr, output_filename)
    @writer = Filewrite_with_row_index.new(output_filename)
    @filenames = filenames_arr 
  end

  # this method starts actual merge. 
  def merge
    @filenames.each do |f_name|
      reader = Fileread_with_row_index.new(f_name)
      last_row = reader.count_row - 1
      for i in 0..last_row 
        line = reader.read_row(i)
        @writer.puts(line)
      end
    end
  end
end
