require 'singleton'

module Dagon
  module Core
    class True < DG_Object
      include Singleton
      def initialize
        @value = true
        @klass = DG_True_Class.new
      end

      def to_instance
        "true:True"
      end

      def inspect
        "true"
      end
    end

    class DG_True_Class < DG_Class
      def initialize
        super("True", Dagon::Core::DG_Class.new)
        @class_methods.delete(:new)
        boot
      end

      def boot
        add_method '!@', ->(vm, ref) {
          Dfalse
        }
      end
    end
  end
end
