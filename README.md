# Event Emitter

EventEmitter provides an idiomatic asynchronous event-driven architecture by registering listeners functions that are called by named event emits. This shard is heavily inspired by Node.js [events API](https://nodejs.org/api/events.html).

When the ```emit``` method is called, the listeners attached to it will be called (synchronously or asynchronously) with the possibility to pass arguments to it.

The following example shows a simple EventEmitter usage with a single listener.

```crystal
require "event_emitter"

class MyEmitter
  include EventEmitter::DSL

  on :connect, sync: true do |name|
    puts "Hello #{name}"
  end

  def connect(name)
    emit :connect, name
  end
end

emitter = MyEmitter.new
emitter.connect("Hugo")
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  event_emitter:
    github: hugoabonizio/event_emitter.cr
```

## Usage

### Synchronous and asynchronous

A listener can execute a block synchronously or asynchronously depending on the argument ```sync``` it is passed.

```crystal
# Asynchronous (executed in another fiber)
on :message, do |message|
  puts "ASYNC: Message: #{message}"
end

# Synchronous
on :connect, sync: true do |name|
  puts "SYNC: Hello #{name}"
end
```

### Passing arguments to the listeners

```crystal
class MyEmitter
  include EventEmitter::DSL

  on :finish do |id, name|
    puts "Hello #{name} (#{id})"
  end

  def perform(name)
    id = User.create(name)
    emit :finish, id, name
  end
end
```

### Multiple listeners

It is possible to register more than one listener to a given event by calling (previous_def)[https://crystal-lang.org/docs/syntax_and_semantics/methods_and_instance_variables.html] inside the block making the blocks stackable. If the listeners are async, each one is executed in its own fiber concurrently.

```crystal
on :message do |message|
  previous_def(message)
  log "Message received: #{message}"
end
```

## Contributing

1. Fork it ( https://github.com/hugoabonizio/event_emitter.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [hugoabonizio](https://github.com/hugoabonizio) Hugo Abonizio - creator, maintainer
