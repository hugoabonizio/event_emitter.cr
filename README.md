# event_emitter

TODO: Write a description here

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  event_emitter:
    github: hugoabonizio/event_emitter.cr
```

## Usage

```crystal
require "event_emitter"

class MyEmitter
  include EventEmitter::DSL

  on :connect do |name|
    puts "hello #{name}"
  end

  def teste
    emit :connect, "!!!"
  end
end

MyEmitter.new.teste

```

## Contributing

1. Fork it ( https://github.com/hugoabonizio/event_emitter.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [hugoabonizio](https://github.com/hugoabonizio) Hugo Abonizio - creator, maintainer
