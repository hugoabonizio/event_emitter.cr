module EventEmitter
  class Base
    record Event, id : Int32, event : String | Regex, listener : Any ->, once : Bool = false
    @events = [] of Event

    # Listen to all events and run the specified block. This is the
    # same as doing `emitter.on(/.*/) { ... }`
    def all(once = false, &block : Any ->)
      on(/.*/, once: once, &block)
    end

    # Listen for a particular `event` and fire the block
    # every time that event is called. If `once` is `true`
    # the event will be removed after it is fired the
    # first time.
    def on(event, *, once = false, &block : Any ->)
      event = event.to_s unless event.is_a?(Regex)

      id = @events.empty? ? 0 : @events.last.id + 1
      @events << Event.new(
        id: id,
        event: event,
        listener: block,
        once: once
      )
      id
    end

    # Sugar for `on(event, once: true)`. Will fire the
    # event once and then remove the listener.
    def once(event, &block : Any ->)
      on(event, once: true, &block)
    end

    # Emit an event with the specified `arg`
    def emit(event, arg = nil)
      event = event.to_s unless event.is_a?(String)

      @events.each do |e|
        spawn do
          case e.event
          when Regex
            if event =~ e.event
              listener = e.listener
              listener.call(EventEmitter.any(arg))
            end
          when event
            listener = e.listener
            listener.call(EventEmitter.any(arg))
          end

          if e.once
            remove_listener(e.id)
          end
        end
      end

      Fiber.yield
    end

    # Remove an event listener by id or event.
    def remove_listener(id_or_event)
      if id_or_event.is_a?(Int)
        @events = @events.reject { |e| e.id == id_or_event }
      else
        event = id_or_event.is_a?(Regex) ? id_or_event : id_or_event.to_s
        @events = @events.reject { |e| event == e.event }
      end
    end
  end
end
