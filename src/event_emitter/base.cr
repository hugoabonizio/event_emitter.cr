module EventEmitter
  class Base 
    @all_handler : Proc(String, Any, Nil)? = nil
    @channels = Hash(String, Array(Channel::Unbuffered(Any))).new

    def all(&block : String, Any ->)
      @all_handler = ->(event : String, response : Any) {
        block.call(event, response)
      }
    end

    def on(event, &block : Any ->)
      event = event.to_s
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
      arg = EventEmitter.any(arg)
      
      @all_handler.try &.call(event.to_s, arg)
      
      @channels[event]?.try &.each do |channel|
        channel.send(arg)
      end
    end
  end
end
