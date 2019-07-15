module EventEmitter
  class Base
    @channels = Hash(Symbol, Array(Channel::Unbuffered(Any))).new

    def on(event, &block : Any ->)
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
      @channels[event].each do |channel|
        arg = EventEmitter.any(arg)
        channel.send(arg)
      end
    end
  end
end
