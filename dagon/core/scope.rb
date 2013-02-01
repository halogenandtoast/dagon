module Dagon
  module Core
    class UndefinedError < StandardError; end
    class Scope
      attr_reader :object, :defines
      def initialize object, parent_scope = NullScope.new
        @object = object
        @parent_scope = parent_scope
        @defines = {}
        object.public_methods(false).map do |method|
          @defines[method] = object.method(method)
        end
      end

      def error string
        $stderr.puts string
      end

      def define name, value
        defines[name] = value
      end

      def define_method name, code_block
        method = @object.define_dagon_method(name, code_block)
        defines[name] = method
      end

      def lookup name
        begin
          defines.fetch(name.to_sym) { @parent_scope.lookup(name) }
        rescue UndefinedError
          error("Undefined variable or method #{name} for #<#{@object.class}:#{@object.to_s}>")
          raise
        end
      end

      def to_s
        defines.keys.inspect
      end
    end

    class NullScope
      def lookup name
        raise UndefinedError
      end
    end
  end
end
