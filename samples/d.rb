require 'terminator'

trap = lambda{ puts "signaled @ #{ Time.now.to_i }" }

Terminator.terminate :seconds => 1, :trap => trap do
  sleep 2
  puts "woke up  @ #{ Time.now.to_i }"
end
