class PGNotify

  def initialize(channel)
    @channel = channel
    @subscribers = {}
    @mutex = Mutex.new
  end

  def subscribe(object, &block)
    @subscribers[object] = block
    setup_listener
  end

  def unsubscribe(object)
    @subscribers.delete object
  end

  def setup_listener
    @mutex.synchronize do
      unless @bgthread
        @bgthread = true
        Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do |connection|
            pg_conn = connection.instance_variable_get(:@connection)
            pg_conn.async_exec "listen #{@channel}"
            begin
              loop do
                pg_conn.wait_for_notify do |channel, pid, payload|
                  json = JSON.parse payload, symbolize_names: true
                  @subscribers.each{ |_, block| block.call json }
                end
              end
            ensure
              @bgthread = false
              pg_conn.async_exec "unlisten #{@channel}"
            end
          end
        end
      end
    end
  end

  def notify(data)
    data = data.to_json.gsub("'", "''")
    ActiveRecord::Base.connection.execute "notify #{@channel}, '#{data}'"
  end
end
