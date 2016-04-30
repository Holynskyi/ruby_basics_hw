def hytro_reverse (initial_array)
	return initial_array.map.with_index{|x,i|initial_array[-i-1]}
end	#коду небагато, але мене тєрзают смутниє сомнєнія, чи мав я право використовуати map.with_index - від нього попахує циклом

input=[0,1,"dva",3.14,4,5,6,7.0]
output=hytro_reverse (input)

puts input
puts"---------"
puts output
