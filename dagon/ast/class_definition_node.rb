require 'core/frame'
require 'core/class'

module Dagon
  module Ast
    class ClassDefinitionNode < Node
      def initialize filename, line_number, class_name, statements
        super filename, line_number
        @class_name = class_name
        @statements = statements
      end

      def evaluate interpreter
        klass = interpreter.dagon_define_class @class_name, Dagon::Core::DG_Class.new
        frame = Dagon::Core::Frame.new(klass, klass.name)
        interpreter.push_frame frame
        @statements.each do |statement|
          statement.evaluate interpreter
        end
        interpreter.pop_frame
      end
    end
  end
end
