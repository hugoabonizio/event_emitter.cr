module EventEmitter
  class Base
    # TODO make recursive types work
    alias Any = Nil |
                Bool |
                Int16 |
                Int32 |
                Int64 |
                Float32 |
                Float64 |
                String
    # Array(Any) |
    # Hash(String, Any)
    @channels = Hash(Symbol, Array(Channel::Unbuffered(Any))).new

    def on(event, block : T ->) forall T
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

    def on(event, &block)
      channel = Channel::Unbuffered(Any).new
      if @channels.has_key? event
        @channels[event] << channel
      else
        @channels[event] = [channel]
      end

      spawn do
        loop do
          channel.receive
          block.call
        end
      end
    end

    def once(event, block : T ->) forall T
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

    def once(event, &block)
      channel = Channel::Unbuffered(Any).new
      if @channels.has_key? event
        @channels[event] << channel
      else
        @channels[event] = [channel]
      end

      spawn do
        channel.receive
        block.call
        @channels[event].delete(channel)
      end
    end

    def emit(event, arg = nil)
      @channels[event].each do |channel|
        channel.send(arg)
      end
    end
  end
end
