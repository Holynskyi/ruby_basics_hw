ROZRYAD=95

def to95(s)#перетворює стрічку-число в 95-розрядне число,ефективніше було б взяти 127, але так отримана стрічка читабельна людині
 #puts("to95 enter, input=#{s}")
 number=s.to_i(16)# в десяткову систему
 srting95=""
 while number>0#доки щось є, видобуваємо цифри
  srting95.insert(0,(number.modulo(ROZRYAD)+32).chr)#справа почергово записуємо остачу від ділення на розряд в стрічку, перетворивши на ASCII символ від 32 до 126 - імпровізована "цифра" 95розрядного числення 
  number=number/ROZRYAD# ділимо на розряд, оскільки забрали одну "цифру"
 end
return srting95
end

def from16to95(str)	#метод розбирається з проблемою нулів на початку числа
 #puts ("from16to95 enter, input=#{str}")
 temp=to95(str)	#отримуємо переторене 95розрядне число, але нулі поки що зігноровані
 zeroes_number=str.length-((str.to_i(16)).to_s(16)).length	#визначаємо к-сть нулів
 if zeroes_number!=0
  temp.insert(0,"о")	#вставляємо напочаток к-сть нулів і кириличне "о"
  temp.insert(0,zeroes_number.to_s)
 end
 return temp
end



def from95to16 (a)# обернений до deal_with_int
 #p "from95to16 enter, input=#{a}"
 str=a.dup
 if str.include?("о")	#якщо є нулі, записуємо їхню к-сть і видаляємо
  zero_number=(str[0...str.index('о')]).to_i
  str.slice!(0..str.index('о'))
 else
  zero_number=0
 end 
 decimal=0
 (str.length-1).downto(0){|i| b=str[i].ord; decimal+=(b-32)*(ROZRYAD**(str.length-i-1))} #розкодовуємо з 95 в 10
 str=decimal.to_s(16)	#з 10 в 16
 str.insert(0,('0'*zero_number))	#дописуємо нулі
 return str
end

input="aAAAbcdefff73847637f3f3aF456464edcFF0"
output=from16to95(input)
restored=from95to16(output)
p "       input line=#{input}"
p "  compressed line=#{output}"
p "decompressed line=#{restored}"





