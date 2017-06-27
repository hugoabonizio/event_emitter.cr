module EventEmitter
  class Base
    # TODO make recursive types work
    alias Any = Nil |
                Bool |
                Int64 |
                Float64 |
                String
    # Array(Any) |
    # Hash(String, Any)
    @channels = Hash(Symbol, Array(Channel::Unbuffered(Any))).new([] of Channel::Unbuffered(Any))

    def on(event, block : T ->) forall T
      channel = Channel::Unbuffered(Any).new
      @channels[event] << channel

      spawn do
        loop do
          block.call(channel.receive)
        end
      end
    end

    def on(event, &block) forall T
      channel = Channel::Unbuffered(Nil).new
      @channels[event] << channel

      spawn do
        loop do
          channel.receive
          block.call
        end
      end
    end

    def emit(event, arg = nil)
      @channels[event].each do |channel|
        channel.send(arg)
      end
    end
  end
end
