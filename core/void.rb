require 'singleton'

module Dagon
  module Core
    class Void < DG_Object
      include Singleton
      def initialize
        @klass = DG_VoidClass.new
      end

      def to_s
        ""
      end

      def value # TODO: determine if there is a better way than this for checking equality
        nil
      end

      def inspect
        "void"
      end
    end

    class DG_VoidClass < DG_Class
      def initialize
        super("Void", Dagon::Core::DG_Class.new)
      end

      def boot
        @class_methods.delete(:new)
        add_method "=", ->(vm, ref, other) {
          ref == other ? Dtrue : Dfalse
        }
      end
    end
  end
end
