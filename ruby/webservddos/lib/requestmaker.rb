require 'httpclient'

count = 20
target = "http://localhost:3000/"

client = HTTPClient.new


puts "-- requestmaker: start --"
puts "  target: "+target,"  #requests: "+count.to_s

for i in (1..count)
  puts "  "+i.to_s+". request done"
  client.get_content(target)
end

puts "-- requestmaker: end --"