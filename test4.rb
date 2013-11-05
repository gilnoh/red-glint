# threaded version for test3 
# Q: why thread? not as simple processes? (easier with processes) 
# A: Due to high memory usage: need to share one big A-transpose matrix. (feature_vectors). 
#
# NOTE: (Oh fuck!) Due to GIL (global interpreter lock), only JRuby can take benefit of this multi-thread on speed issue. 
# normal ruby interpreter just uses one thread and emulate them. 


require 'time' 
require_relative 'File_with_row_index'

# global constant 
NUM_THREADS = 4
CHUNK_SIZE = 100 
OUTFILE_PREFIX = "BB_matrix"

arg_check
##
## first, load the feature vectors. 
t1 = Time.new 

$fvectors_arr = Array.new
File.open(ARGV[0]).each_line do |line|
  id_string, vector_string = line.split("\t\t")
  id = id_string.to_i
  if ($fvectors_arr[id]) # sanity check, this can't exist yet. 
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
  $fvectors_arr[id]= Hash[*tmp] # as hash 
  #$fvectors_arr[id]= tmp # as array 
end

# dcode, walk over the fvector_arr, where each member is a hash 
#$fvectors_arr.each_with_index do |h, i|
#  print "#{i}\t"
#  h.keys.sort.each do |k|
#    print("#{k}:#{h[k]}\t")
#  end
#  print "\n" 
#end 

t2 = Time.new 
tdiff_1_2 = t2 - t1
$stderr.puts("Loading complete: time took #{tdiff_1_2}") 

##
## second, (with the loaded vectors), calculate from - to 
## from here, it is different from test3 scripts 

from = ARGV[1].to_i
to = ARGV[2].to_i

# sanity chcek 
if (from < 0)
  from = 0
end 

if (to > $fvectors_arr.size)
  to = $fvectors_arr.size - 1 
end 

outfilename = sprintf("%s.%07d_to_%07d.out", OUTFILE_PREFIX, from, to)
indexed_file = Filewrite_with_row_index.new(outfilename)

abs_start_point = from 
abs_end_point = to 

cursor_point = abs_start_point 
from_of_thread_n = Array.new(NUM_THREADS) # from_of_thread_n(n) holds thread N's start point 
to_of_thread_n = Array.new(NUM_THREADS)  # from_of_thread_n(n) holds thread N's end point 
thread = Array.new(NUM_THREADS) 

# loop here 
while (cursor_point <= abs_end_point) 
  # generate *next* from/to for each threads 
  for n in 0..(NUM_THREADS - 1) 
    if (cursor_point > abs_end_point)
      from_of_thread_n[n] = nil 
      to_of_thread_n[n] = nil 
      next # needed! (so all remaining next threads will have nil for start position, and won't be called) 
    end
    from_of_thread_n[n] = cursor_point
    to_of_thread_n[n] = cursor_point + CHUNK_SIZE - 1 
    if (to_of_thread_n[n] > abs_end_point) 
      to_of_thread_n[n] = abs_end_point 
    end  
    cursor_point = cursor_point + CHUNK_SIZE # move for next
  end
 
  # Okay. run the threads 
  for n in 0..(NUM_THREADS - 1)
    if (from_of_thread_n[n])
      # example 
      #thread[n] = Thread.new{print_from_to(from_of_thread_n[n], to_of_thread_n[n])} # this doesn't work!!! from/to_of_thread will be shared.
      #thread[n] = Thread.new(from_of_thread_n[n], to_of_thread_n[n]){|f, t| print_from_to(f,t)} # But this is Okay. :-) This is the way. 
      
      thread[n] = Thread.new(from_of_thread_n[n], to_of_thread_n[n]){|f, t| calc_rows_of_B(f, t)} 
    else
      thread[n] = nil 
    end
  end

  # wait for results and print them out   
  for n in 0..(NUM_THREADS - 1)
    if (thread[n] == nil)
      next 
    end
    # get thread n's result, and output to file 
    one_result = thread[n].value 
    raise "intergrity failure" if not (from_of_thread_n[n])
    id = from_of_thread_n[n] # init the first id 
    one_result.each do |one_vector_hash|
      output_line = "" 
      temp = sprintf "%d\t\t", id
      output_line.concat(temp)
      lastkey = 0
      one_vector_hash.keys.sort.each do |k|  # note that we have keys sorted: 
        keydelta = k - lastkey # so we can actually do this delta... 
        temp = sprintf "%d:%.2f\t", keydelta, one_vector_hash[k] # only 2 digits under . 
        output_line.concat(temp)
        lastkey = k
      end
      indexed_file.puts(output_line)
      id = id+1
    end # of per-thread result fetch-output 

  end # of while 
end


# work on that with threads ... 




# # # prior check, without threads. 
# # one_result = calc_rows_of_B(from, to) 

# # id = from # this is needed for each from!! 
# # one_result.each do |one_vector_hash|
# #   output_line = "" 
# #   temp = sprintf "%d\t\t", id
# #   output_line.concat(temp)
# #   lastkey = 0
# #   one_vector_hash.keys.sort.each do |k|  # note that we have keys sorted: 
# #     keydelta = k - lastkey # so we can actually do this delta... 
# #     temp = sprintf "%d:%.2f\t", keydelta, one_vector_hash[k] # only 2 digits under . 
# #     output_line.concat(temp)
# #     lastkey = k
# #   end
# #   indexed_file.puts(output_line)
# #   id = id+1
# # end


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

def calc_rows_of_B(from, to) 

  result_arr = [] # result to return 

  (from..to).each do |i| 
    # calculate row i of B matrix. 
    target_h = $fvectors_arr[i]
    result_B_vec = Hash.new 
    $fvectors_arr.each_with_index do |h, i|
      val = inner_product_hh(target_h, h)
      if (val > 0.0)
        result_B_vec[i] = val
      end
    end
    # store the result to result_arr 
    result_arr.push(result_B_vec)
  end
  return result_arr 
end

def print_from_to(local_from, local_to)
  s = sprintf("working - %s to %s", local_from, local_to) 
  $stderr.puts(s)
  return s
end

}



