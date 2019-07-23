require "json"
require "yaml"
require "./event_emitter/*"

module EventEmitter
  alias Any = Void |
              Nil |
              Bool |
              Int16 |
              Int32 |
              Int64 |
              Float32 |
              Float64 |
              String |
              Symbol |
              Array(Any) |
              Hash(Any, Any) |
              JSON::Any |
              YAML::Any

  # TODO: See if there isn't a better way to do this
  def self.any(any)
    case any
    when Array
      any.map { |a| any(a).as(Any) }
    when Hash
      any.map { |k, v| {any(k).as(Any), any(v).as(Any)} }.to_h
    else
      any
    end
  end
end
