require 'terminator'

Terminator.terminate 0.2 do
  sleep 0.4 rescue puts 'timed out!'
end
