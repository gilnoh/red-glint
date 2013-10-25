# this small script changes typical line of TypeDM 
# element \t feature \t score \n
# format into.  
# feature \t element \t score \n 

require 'time' 

if not ARGV[0]
  puts "Requires one filename that has element\tfeature\tscore text."
  exit 
end

filename = ARGV[0]

t1 = Time.new 

# step #1 collect them 
feature_hash = Hash.new # holds array where each element is another array that represent one line as [feature, element, score] 
File.open(filename).each_line do |line|
  t = line.force_encoding("iso-8859-1").split  # some invalid sequence requires this force encoding
  unit = [t[1], t[0], t[2]]
  if not feature_hash.key?(t[1])
    feature_hash[t[1]] = Array.new 
  end
  feature_hash[t[1]].push(unit)
end

t2 = Time.new 
diff_1_2 = t2 - t1
$stderr.puts "Time took for collecting: #{diff_1_2}"

# step #2 print them, with order. 
feature_hash.keys.sort.each do |feature| # sorted order of features 
  feature_hash[feature].sort.each do |unit| # again sorted units 
    puts unit.join("\t")
  end 
end

t3 = Time.new 
diff_2_3 = t3 - t2
diff_1_3 = t3 - t1 
$stderr.puts "Time took for printing: #{diff_2_3}" 
$stderr.puts "Total, it took: #{diff_1_3}"


## remark 
## not a bad idea, neat code. but takes too much memory. 
