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

def alt_reverse(initial_array,reverse_array=initial_array,i=0)
	if i==0
		reverse_array=initial_array.dup
	end
	reverse_array[i]=initial_array[-i-1]
	i=i+1
	if i>=initial_array.length
		return reverse_array
	else
		reverse_array=alt_reverse(initial_array,reverse_array,i)
	end

end

input=[0,1,"dva",3.14,4,5,6,7.0]
output=alt_reverse (input)

puts input
puts"---------"
puts output
