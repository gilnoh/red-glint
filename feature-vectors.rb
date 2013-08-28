# Generate feature vectors from 
# from files, only. 

# input: element \t feature \t score 
#-m-n	nmod-1+construction-n	3.8055
#-m-n	nmod-1+current-j	5.2503
#-m-n	nmod-1+cvs-n	59.1740
#-m-n	nmod-1+daemon-n	15.9402
#-m-n	nmod-1+de-n	12.2386

# output
# nmod-1+construction-n -m-n 3.8055
# nmod-1+construction-n -m-z 1.11 
# ... 

# without using excessive memory. (under 4G, hopefully, or at least the file size) 


feature_hash = Hash.new([]);  # each hash item will hold an array 
filename = "t"
#"word-link+word.txt"
# first: store all according to 2nd column (feature column) 
File.open(filename).each_line do |line|
  t = line.split
  unit = [t[1], t[0], t[2]]
  
  if not feature_hash.key?(t[1])
    feature_hash[t[1]] = Array.new 
  end 
  #for example, feature_hash[nmod-1+de-n].push([nmod-1+de-n, -m-n, 12.2386])
  feature_hash[t[1]].push(unit) 
end

# record time?

# second: output 
feature_hash.keys.sort.each do |feature|
  array = feature_hash[feature].sort # may take some time for sort? 
  array.each do |triple|
    puts(triple.join("\t"))
  end
end
