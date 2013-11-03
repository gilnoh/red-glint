# this script makes you to access
# "B matrix" in File_with_row_matrix format + relative index. 
# (that of output test3c and test4 ...)

# this script shows how to load a row of a B matrix. 
# TODO? use this script to test test3c output is equivalent to test3a output

require_relative "File_with_row_index"

if not (ARGV[0] and File.readable?(ARGV[0]))
   $stderr.puts "usage: ruby script.rb row_indexed_datafile_name"
   exit
end

fwi = Fileread_with_row_index.new(ARGV[0])

# all right, try to convert all to absolute index
# (only possible for a small example)
last_row = fwi.count_row - 1 
#for i in 0..last_row
for i in 0..10
  line = fwi.read_row(i)
  (row_id, row_values) = line.split("\t\t")
  row_hash = read_rvals_to_hash(row_values)

  print "#{row_id}\t\t"
  row_hash.keys.sort.each do |k|
    printf "%d:%.2f\t", k, row_hash[k]
  end
  print "\n"
#  result_B_vec.keys.sort.each do |k|
#    #print "#{k}:#{result_B_vec[k]}\t"
#    printf "%d:%.2f\t", k, result_B_vec[k] # only 2 digits under . 
#  end
#  print "\n"  

end

BEGIN {
def read_rvals_to_hash(str)
  result = Hash.new
  prev_index = 0
  temparr = str.split("\t")
  temparr.each do |v|
    (rel_index, val) = v.split(":")
    abs_index = 0
    abs_index = prev_index + rel_index.to_i
    result[abs_index] = val.to_f
    prev_index = abs_index 
  end
  return result 
end
}
