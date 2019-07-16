module EventEmitter
  class Base
    @channels = Hash(String, Array(Channel::Unbuffered(Any))).new

    def on(event, &block : Any ->)
      event = event.to_s unless event.is_a?(String)
      channel = Channel::Unbuffered(Any).new
      if @channels.has_key? event
        @channels[event] << channel
      else
        @channels[event] = [channel]
      end

      spawn do
        loop do
          block.call(channel.receive)
        end
      end
    end

    def once(event, &block : Any ->)
      event = event.to_s unless event.is_a?(String)
      channel = Channel::Unbuffered(Any).new
      if @channels.has_key? event
        @channels[event] << channel
      else
        @channels[event] = [channel]
      end

      spawn do
        block.call(channel.receive)
        @channels[event].delete(channel)
      end
    end

    def emit(event, arg = nil)
      event = event.to_s unless event.is_a?(String)
      @channels[event].each do |channel|
        arg = EventEmitter.any(arg)
        channel.send(arg)
      end
    end
  end
end
