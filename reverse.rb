def hytro_reverse(initial_array , i=0)
	initial_array[i], initial_array[-i-1]=initial_array[-i-1], initial_array[i] 	
	i=i+1
	if i<initial_array.length/2
		reverse_array=hytro_reverse(initial_array ,i)
	else 		
		return initial_array
	end
end	

def my_reverse(arr)
	m=arr.dup
	return hytro_reverse(m)
end

input=[0,1,"dva",3.14,4,5,6,7.0]
output=my_reverse (input)

puts input
puts"---------"
puts output
