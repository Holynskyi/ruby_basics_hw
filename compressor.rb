ROZRYAD=95 
CYFRA=['0','1','2','3','4','5','6','7','8','9']

def to95(s)#перетворює стрічку-число в 95-розрядне число,ефективніше було б взяти 127, але так отримана стрічка читабельна людині
 #puts("to95 enter, input=#{s}")
 number=s.to_i
 srting95=""
 while number>0#доки щось є, видобуваємо цифри
  srting95.insert(0,(number.modulo(ROZRYAD)+32).chr)#справа почергово записуємо остачу від ділення на розряд в стрічку, перетворивши на ASCII символ від 32 до 126 - імпровізована "цифра" 95розрядного числення 
  number=number/ROZRYAD# ділимо на розряд, оскільки забрали одну "цифру"
 end
return srting95
end

def deal_with_int(str)	#метод розбирається з проблемою нулів на початку числа
 #puts ("deal_with_int enter, input=#{str}")
 temp=to95(str)	#отримуємо переторене 95розрядне число, але нулі окищо зігноровані
 temp<<("я")	#символом "я" маркуємо кінець 95розрядного числа
 zeroes_number=str.length-((str.to_i).to_s).length	#визначаємо к-сть нулів
 if zeroes_number!=0
  temp.insert(0,"о")	#вставляємо напочаток к-сть нулів і кириличне "о"
  temp.insert(0,zeroes_number.to_s)
 end
 temp.insert(0,"0")	#вставляємо 0 на початок як маячок про початок закодованого числа
 return temp
end


def compres(s)
 initial_str=s.dup 
 length_of_int=0
 factor=1 
 i=0
 combo_begin=0
 while i<=initial_str.length
  #p "#{i} starts, line now: #{initial_str}" 
  if CYFRA.include?(initial_str[i])	#якщо символи-цифри стискування проходитиме за окремим алгоритмом
   #puts "CYFRA"
   if length_of_int==0	#якщо початок цифрової послідовності, то позначимо це
    #p "numeric begin"
    if factor!=1	#випадок переривання послідовності символів
     #puts "normal compres"
     initial_str.slice!(combo_begin...i-1)	#вирізаємо групу однакових символів крім одного				
     initial_str.insert(combo_begin,factor.to_s)	#перед цим залишеним символом вставляємо кількість однакових
     i=combo_begin+(factor.to_s).length+1	#враховуючи скорочення стрічки повертаємось на необхідну відстань назад
     factor=1	#скидаємо лічильник
    end
    length_of_int+=1
    int_begin=i
   end
  elsif CYFRA.include?(initial_str[i-1]) && i!=0		#симфол не цифра, але перед ним цифри
   #puts "numeric compres"
   num=deal_with_int(initial_str.slice!(int_begin...i))
   initial_str.insert(int_begin,num)
   i=int_begin+num.length	#враховуючи скорочення стрічки повертаємось на необхідну відстань назад
   combo_begin=i
   length_of_int=0
  elsif initial_str[i]==initial_str[i-1] && i!=0
   #puts "initial_str[i]==initial_str[i-1]"
   factor+=1 	#якщо біжучий символ тотожній попередньому - лічильник наростає
  elsif factor!=1   #випадок переривання послідовності символів
   #puts "normal compres"
   initial_str.slice!(combo_begin...i-1)	#вирізаємо групу однакових символів крім одного				
   initial_str.insert(combo_begin,factor.to_s)	#перед цим залишеним символом вставляємо кількість однакових
   i=combo_begin+(factor.to_s).length	#враховуючи скорочення стрічки повертаємось на необхідну відстань назад
   factor=1	#скидаємо лічильник
  else	#символ новий, не цифра і не йде після послідовності чи числа
   #puts "else"
   combo_begin=i	#встановлюємо початок відліку тотожніх символів
  end
  i=i+1 
 end
 return initial_str
end



def from95 (a)# обернений до deal_with_int
 #p "from95 enter, input=#{a}"
 str=a.dup
 str.chop!	#обрізаємо сигнальні краї
 str.slice!(0)
 if str.include?("о")	#якщо є нулі, записуємо їхню к-сть і видаляємо
  zero_number=(str[0...str.index('о')]).to_i
  str.slice!(0..str.index('о'))
 else
  zero_number=0
 end 
 decimal=0
 (str.length-1).downto(0){|i| b=str[i].ord; decimal+=(b-32)*(ROZRYAD**(str.length-i-1))} #розкодовуємо з 95 в 10
 str=decimal.to_s
 str.insert(0,('0'*zero_number))	#дописуємо нулі
 return str
end


def decompressor(a)
 #p "decompressor enter, input=#{a}"
 s=a.dup
 i=0
 norm_dec=false
 num_dec=false
 while i<=s.length
  #p "#{i} starts, line=#{s}"
  if s[i]=='0' && !norm_dec && !num_dec		#вільний нуль, що позначає початок 95розрядного числа
   num_dec=true
   dec_begin=i
  elsif s[i]=='я' && !norm_dec && num_dec	#я, що позначає кінець 95розрядного числа
   temp=from95(s.slice!(dec_begin..i))
   s.insert(dec_begin, temp)	#вирізаємо і надсилаємо 95розрядне число, вставляємо відновлене десяткове
   i=dec_begin+temp.length-1
   num_dec=false
  elsif CYFRA.include?(s[i]) && !norm_dec && !num_dec	#вільна цифра-не нуль-показує початок індекса звичного стиснення
   norm_dec=true
   dec_begin=i
  elsif !CYFRA.include?(s[i]) && norm_dec && !num_dec	#симфол(нецифровий) якого стосується вищезгаданий показник стиснення
   temp=s[i]
   temp_i=(s.slice!(dec_begin..i)).to_i#розмножуємо необхідний символ числом(не обовязково цифрою), яке стоїть перед ним 
   s.insert(dec_begin,temp*temp_i)
   i=dec_begin+temp_i-1
   norm_dec=false
  end
 i=i+1
 end
return s
end

input="00012345aaaahfduuul,   ===678```~~~ЇЇЇЇЇьууWWWWW1219087654"
output=compres(input)
restored=decompressor(output)
p "       input line=#{input}"
p "  compressed line=#{output}"
p "decompressed line=#{restored}"


