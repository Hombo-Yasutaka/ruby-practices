(1..20).each do |num|
  case
  when num % 15 == 0
    puts "FizzBuzz"
  when num % 5  == 0
    puts "Buzz"
  when num % 3  == 0
    puts "Fizz"
  else
    puts num 
  end
end