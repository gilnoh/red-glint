#/usr/bin/ruby 

# multithread test 
@global_readonly = [1,2,3,4,5,6,7,8,9,10] 

def sum_by_index(from, to)
  result = 0
  for j in 1..1000
    for i in from..to 
      result = result + @global_readonly[i]
    end
  end
  return result 
end

t1 = Thread.new{sum_by_index(0,4)}
t2 = Thread.new{sum_by_index(5,8)}
val1 = t1.value 
val2 = t2.value
puts ("Result, #{val1}, #{val2}") 


