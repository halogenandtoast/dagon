require 'core/integer'
require 'core/float'

module Dagon
  module AST
    class LiteralNode < Node
      def initialize filename, line_number, literal
        super filename, line_number
        @value = literal
      end

      def evaluate interpreter
        case @value.class.name
        when "Fixnum" then interpreter.get_class("Integer").instance(@value)
        when "Float" then interpreter.get_class("Float").instance(@value)
        when "TrueClass" then Dtrue
        when "FalseClass" then Dfalse
        when "NilClass" then Dvoid
        end
      end
    end
  end
end
