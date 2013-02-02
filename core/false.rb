require 'singleton'

module Dagon
  module Core
    class False < DG_Object
      include Singleton

      def initialize
        @value = false
        @klass = DG_False_Class.new
      end

      def to_instance
        "false:False"
      end

      def inspect
        "false"
      end
    end

    class DG_False_Class < DG_Class
      def initialize
        super("False", Dagon::Core::DG_Class.new)
        @class_methods.delete(:new)
        boot
      end

      def boot
        add_method '!@', ->(vm, ref) {
          Dtrue
        }
      end
    end
  end
end
