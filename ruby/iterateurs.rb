puts "Iterateurs"
puts
puts "Iterateurs de nombres"
puts
puts "for n in 2..7"
for n in 2..7
  print n, " "
end
puts "\n2.upto(7)"
2.upto(7) { |x| print x, " " }
puts "\n2.upto(7) v2"
2.upto(7) do |var|
  print var," "
end
puts "\n7.downto(2)"
7.downto(2) { |x| print "#{x} " }
puts "\n2.times"
2.times { |x| print x," " }
puts
puts "\nParcourir un tableau"
puts
array = ["zero", "un", "deux"]
puts "array.each { |n| puts n }"
array.each { |n| print n," " }
puts "\nfor n in array
  puts n
end"
for n in array
  print n, " "
end