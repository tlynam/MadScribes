module PGNotify
  def listen_for(channel)
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        conn = connection.instance_variable_get(:@connection)
        conn.async_exec "listen #{channel}"
        loop do
          conn.wait_for_notify do |notified_channel, pid, payload|
            if channel == notified_channel
              yield JSON.parse(payload, symbolize_names: true)
            end
          end
        end
      end
    end
  end

  def notify(channel, data)
    data = data.to_json.gsub("'", "''")
    ActiveRecord::Base.connection.execute "notify #{channel}, '#{data}'"
  end
end
