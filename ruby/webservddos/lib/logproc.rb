# Script processing web/proxy server log in csv format
# @author Marek Aufart, aufi.cz@gmail.com

#Example request:
# "$time_local","$remote_addr","$status","$request_length","$body_bytes_sent","$request_time","$connection","$pipe","$host","$request","$http_referer","$http_user_agent"
#0 06/Apr/2011:15:07:30 +0200
#1 147.32.31.193
#2 304
#3 1000
#4 0
#5 0.011
#6 1651
#7 .
#8 dev.aurem.cz
#9 GET /modules/poll/poll.css?e HTTP/1.1
#10 http://dev.aurem.cz/geolokace
#11 Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.204 Safari/534.16
#

require 'csv'

class CSV_log
  
  def initialize(filename)  
    puts "  logfile: ",filename   
    @filename = filename  
    @rows = CSV.read(@filename)
    @clients = Hash.new
  end
  
  def pass
    @rows.each { |r| request(r) }
  end
  
  def stats
    puts "-- logprocess: printing statistics --"
    @clients.each_value { |c| puts c.print_stats }
  end
  
  private
  
  def request(r)
    id = get_client_hash(r[1], r[11])
    if @clients.include?(id)  #fast: if !@clients[id].nil? instead of include
      @clients[id].add_req(r)
    else
      #by referer
      @clients[id] = Client.new(r)
    end  
    puts "  processing request from: "+id
  end
  
end

class Client
  @id
  @request_count #only for results significance (eg. >10 for possible deny)
  @notmod_count
  @avg_time
  #@pages proc.time division
  #next params
  
  def initialize(req)  
    @id = get_client_hash(req[1], req[11])
    puts "  creating a new client: "+@id
    @request_count = 1
    @notmod_count = 0
    @avg_time = req[5].to_f
    @avg_time_count = 1
    #@pages = Hash.new
  end
  
  def add_req(req)
    @notmod_count += 1 if req[2].to_i.eql?(304) 
    @avg_time = (@avg_time*@request_count + req[5].to_f)/(@request_count+1)
    @request_count += 1
  end
  
  def print_stats
    return @notmod_count.to_s+"; "+@avg_time.to_s+"; "+@request_count.to_s+"; "+@id.to_s
  end
  
end

def get_client_hash(ip, browser)
  return ip+"_"+browser.delete(' ')
end

puts "-- logprocess: start --"

log = CSV_log.new('../test/log.csv')

log.pass

log.stats

puts "-- logprocess: end --"