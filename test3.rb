# this small test script reads 
# integer-ID-lized feature-vector per-line format 
# and outputs feature x feature inner-product matrix. 
# (rows of so-called B matrix. See memo: ) 

require 'time' 

arg_check

# first, load the feature vectors. 
t1 = Time.new 

fvectors_arr = Array.new
File.open(ARGV[0]).each_line do |line|
  id_string, vector_string = line.split("\t\t")
  id = id_string.to_i
  if (fvectors_arr[id]) # sanity check, this can't exist yet. 
    $stderr.puts("Something is wrong. duplicated feature id #{i}") 
  end
  
  tmp = Array.new 
  vector_string.split.each_with_index do |s, i|
    if (i.even?)
      tmp.push(s.to_i)
    else
      tmp.push(s.to_f)
    end
  end
  fvectors_arr[id]= Hash[*tmp] # as hash 
  #fvectors_arr[id]= tmp # as array 
end

# dcode, walk over the fvector_arr, where each member is a hash 
#fvectors_arr.each_with_index do |h, i|
#  print "#{i}\t"
#  h.keys.sort.each do |k|
#    print("#{k}:#{h[k]}\t")
#  end
#  print "\n" 
#end 

t2 = Time.new 
tdiff_1_2 = t2 - t1
$stderr.puts("Loading complete: time took #{tdiff_1_2}") 

# Using hash, required 7 Gb, with 20 min (1260 secs) 
# Using array, required x.x Gb, with MM min. 

BEGIN{

def usage_print
  puts "  ruby [scriptname].rb feature-vector-filename feature_id_start feature_id_end"
  puts "  it will calculate and output rows of the B matrix, from id_start to id_end" 
end

def arg_check
  if not (ARGV[0] and File.readable?(ARGV[0]))
    usage_print
    exit 
  end

  if not (ARGV[1] and ARGV[2])
    usage_print
    exit
  end
end

}
