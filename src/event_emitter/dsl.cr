module EventEmitter
  module DSL
    macro on(event, sync = false, &block)
      def _on_{{ event.id }}({{ *block.args }})
        {% if sync %}
          {{ block.body }}
        {% else %}
          spawn do
            {{ block.body }}
          end
        {% end %}
      end
    end

    macro emit(event, *args)
      _on_{{ event.id }}({{ *args }})
    end
  end
end
