# this small test script reads 
# integer-ID-lized feature-vector per-line format 
# and outputs feature x feature inner-product matrix. 
# (rows of so-called B matrix. See memo: ) 

require 'time' 

arg_check
##
## first, load the feature vectors. 
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

# Using hash, required 7 Gb, with 20 min (1260 secs), on 17inch-macbook  
# Using array, required x.x Gb, with MM min. 

##
## second, (with the loaded vectors), calculate from - to 
from = ARGV[1].to_i
to = ARGV[2].to_i

# sanity chcek 
if (from < 0)
  from = 0
end 

if (to > fvectors_arr.size)
  to = fvectors_arr.size - 1 
end 

# actual run 
(from..to).each do |i|
  # calculate row i of B matrix. 
  target_h = fvectors_arr[i]
  result_B_vec = Hash.new 

  fvectors_arr.each_with_index do |h, i|
    val = inner_product_hh(target_h, h)
    if (val > 0.0)
      result_B_vec[i] = val
    end
  end

  # print result directly, without storing. 
  # note that this is "not" normalized. 
  # index:val format 
  print "#{i}\t\t"
  result_B_vec.keys.sort.each do |k|
    #print "#{k}:#{result_B_vec[k]}\t"
    printf "%d:%.2f\t", k, result_B_vec[k] # only 2 digits under . 
  end
  print "\n"  
end

t3 = Time.new 
tdiff_1_3 = t3 - t1
tdiff_2_3 = t3 - t2 
$stderr.puts("Calculated B-matrix rows from #{from} to #{to}. Took #{tdiff_2_3} seconds. Total time till now: #{tdiff_1_3}")


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

# gets two hash (with float values), and generate inner product
def inner_product_hh(a,b) 
  r = 0.0 # float num to be accumulated 
  a.keys.each do |k|
    if b[k]
      r = r + (a[k] * b[k]) 
    end
  end
  return r 
end 
}
