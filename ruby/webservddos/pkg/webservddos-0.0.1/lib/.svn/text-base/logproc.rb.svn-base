# To change this template, choose Tools | Templates
# and open the template in the editor.


#Example request:
# date, ip, code, bytes, http pipeline, proc.time, , , http host header, http req text, http referer, browser text
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
  
  private
  
  def get_client_hash(ip, browser)
    return ip+"_"+browser.delete(' ')
  end
  
  def request(r)
    id = get_client_hash(r[1], r[11])
    
    if @clients.include?(id)
      @clients[id].add_req(r)
    else
      @clients[id] = Client.new(r)
    end  
    puts id
  end
  
end

class Client
  @id
  @request_count
  @avg_get
  
  def initialize(req)  
    puts "  creating a new client: ",id
    @request_count = 1
    @avg_get = 0
  end
  
  def add_req(req)
    @request_count += 1
  end
  
end

puts "-- logprocess: start --"

log = CSV_log.new('../test/log.csv')
log.pass


puts "-- logprocess: end --"