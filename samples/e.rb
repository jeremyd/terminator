require 'terminator'

puts "Looping 1000 times on the terminator..."
success = false
1.upto(1000) do |i|
  success = false
  Terminator.terminate(1) do
    success = true
  end
  print "\b\b\b#{i}"
end
puts "\nI was successful" if success
