# run by passing PID: kill -USR2 33434
Signal.trap('USR2') do
  pid = Process.pid 
  puts "[#{pid}] Received USR2 at #{Time.now}. Dumping threads:"
  Thread.list.each do |t|
    trace = t.backtrace.join("\n[#{pid}] ")
    puts "[#{pid}] #{trace}"
    puts "[#{pid}] ---"
  end
  puts "[#{pid}] -------------------"
end