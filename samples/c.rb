require 'terminator'

begin
  Terminator.terminate :seconds => 0.2 do
    sleep 0.4
  end
rescue Terminator.error
  puts 'timed out!'
end
