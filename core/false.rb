require 'singleton'

module Dagon
  module Core
    class False < DG_Object
      include Singleton

      def initialize
        @value = false
        @klass = DG_FalseClass.new
      end

      def inspect
        "false"
      end
    end

    class DG_FalseClass < DG_Class
      def initialize
        super("False", Dagon::Core::DG_Class.new)
      end

      def boot
        @class_methods.delete(:new)
        add_method '!@', ->(vm, ref) {
          Dtrue
        }
      end
    end
  end
end
