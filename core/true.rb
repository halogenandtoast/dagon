require 'singleton'

module Dagon
  module Core
    class True < DG_Object
      include Singleton
      def initialize
        @value = true
        @klass = DG_TrueClass.new
      end

      def inspect
        "true"
      end
    end

    class DG_TrueClass < DG_Class
      def initialize
        super("True", Dagon::Core::DG_Class.new)
      end

      def boot
        @class_methods.delete(:new)
        add_method '!@', ->(vm, ref) {
          Dfalse
        }
      end
    end
  end
end
