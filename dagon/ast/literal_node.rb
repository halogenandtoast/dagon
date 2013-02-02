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
        when "Fixnum" then Dagon::Core::DG_Integer_Class.new.instance(@value)
        when "Float" then Dagon::Core::DG_Float_Class.new.instance(@value)
        when "TrueClass" then Dtrue
        when "FalseClass" then Dfalse
        when "NilClass" then Dvoid
        end
      end
    end
  end
end
