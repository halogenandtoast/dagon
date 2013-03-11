require 'singleton'

module Dagon
  module Core
    class Void < DG_Object
      include Singleton
      attr_reader :value
      def initialize
        @value = nil
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
      undef :dagon_new
      def initialize
        super("Void", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method "=", ->(vm, ref, other) { ref == other ? Dtrue : Dfalse }
        add_method 'inspect', ->(vm, ref) { ref.inspect }
      end
    end
  end
end
