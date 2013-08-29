# this small script reads TypeDM 
# element \t feature \t score \n
# file and outputs 
# ...
# feature_id \t element_id:score \t element_id:score ... \n 
# (one feature per line) 

require 'time' 

if not ARGV[0]
  puts "Requires one filename that has element\tfeature\tscore text."
  exit 
end

filename = ARGV[0]

t1 = Time.new 

# step #1 
# read each line, record all feature/element 
features = Hash.new
elements = Hash.new 

File.open(filename).each_line do |line|
  t = line.force_encoding("iso-8859-1").split 
  if not elements[t[0]] 
    elements[t[0]] = true; 
  end

  if not features[t[1]]
    features[t[1]] = true; 
  end
end

t2 = Time.new 
diff_t1_t2 = t2 - t1
$stderr.puts("#{diff_t1_t2}: scanned elements and features.")

# step #2 
# assign id for each feature, and element
sorted_elements_arr = elements.keys.sort
sorted_features_arr = features.keys.sort 

sorted_elements_arr.each_index do |i|
  elements[sorted_elements_arr[i]] = i
end

sorted_features_arr.each_index do |j|
  features[sorted_features_arr[j]] =j
end

# now features and elements holds id. 

# if you want to print them out 
#features.keys.sort.each { |k|
#  puts "#{k}: #{features[k]}"
#}

#elements.keys.sort.each { |k|
#  puts "#{k}: #{elements[k]}"
#}

t3 = Time.new 
diff_t1_t3 = t3 - t1
$stderr.puts("#{diff_t1_t3}: sorted and assigned ids to elements and features.")

# step 3 
# walk over the file again, generate id based 
# feature per line output 

feature_vectors = Array.new 
File.open(filename).each_line do |line|
  t = line.force_encoding("iso-8859-1").split 
  eid = elements[t[0]]
  fid = features[t[1]]
  score = t[2].to_f 
    
  if not (feature_vectors[fid])
    feature_vectors[fid] = Array.new 
  end

  feature_vectors[fid].push(eid)
  feature_vectors[fid].push(score)
end

# print each line 
feature_vectors.each_index do |i|
#    puts("#{i}\t\t", feature_vectors[i].join("\t"))
     print("#{i}\t\t")
     puts(feature_vectors[i].join("\t"))
end

t4 = Time.new 
diff_t1_t4 = t4 - t1
$stderr.puts("#{diff_t1_t4}: Done feature-vector, per line, sparse output") 


# optional? 
# store list of features and elements in separate files 

f1 = File.new("elements.txt", "w")
f2 = File.new("features.txt", "w") 

elements.keys.sort.each { |k|
  f1.puts "#{k}: #{elements[k]}"
}

features.keys.sort.each { |k|
  f2.puts "#{k}: #{features[k]}"
}
