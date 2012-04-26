require 'terminator'

Terminator.terminate 2 do
  sleep 4 rescue puts 'timed out!'
end
