module Dagon
  module AST
    class InstanceVarRefNode < Node
      attr_reader :variable_name
      def initialize filename, line_number, instance_variable_name
        super filename, line_number
        @instance_variable_name = instance_variable_name
      end

      def evaluate interpreter
        current = interpreter.frame.object.get_instance_variable(@instance_variable_name)
        if current
          current
        else
          interpreter.error("NameError", "No value named #{@instance_variable_name}")
        end
      end
    end
  end
end
