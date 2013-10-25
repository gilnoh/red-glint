

# this ruby class wraps File class, 
# and generates one index file. 

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
    update_index
  end

  def puts(string)
    @data_f.puts(string)
    @cur_num += 1 
    @cur_pos = @data_f.pos 
    update_index
  end
  
  def update_index
    @index_f.puts("#{@cur_num}\t#{@cur_pos}")
  end
end
