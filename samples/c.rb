require 'terminator'

begin
  Terminator.terminate :seconds => 2 do
    sleep 4
  end
rescue Terminator::Error
  puts 'timed out!'
end
