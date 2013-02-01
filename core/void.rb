require 'singleton'

module Dagon
  module Core
    class Void < DG_Object
      include Singleton
      def initialize
        @klass = DG_Void_Class.new
      end

      def to_s
        ""
      end

      def inspect
        "void"
      end
    end

    class DG_Void_Class < DG_Class
      def initialize
        super("Void", Dagon::Core::DG_Class.new)
        @class_methods.delete(:new)
        boot
      end

      def boot
        add_method "=", ->(vm, ref, other) {
          ref == other ? Dtrue : Dfalse
        }
      end
    end
  end
end
