require 'singleton'

module Dagon
  module Core
    class False < DG_Object
      include Singleton
      attr_reader :value

      def initialize
        @value = false
        @klass = DG_FalseClass.new
      end

      def inspect
        "false"
      end

      def to_s
        "false"
      end
    end

    class DG_FalseClass < DG_Class
      undef :dagon_new
      def initialize
        super("False", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method '!@', ->(vm, ref) {
          Dtrue
        }
        add_method '=', ->(vm, ref, other) {
          ref == other ? Dtrue : Dfalse
        }
        add_method '&&', ->(vm, ref, other) { Dfalse }
        add_method '||', ->(vm, ref, other) { other }
        add_method '^', ->(vm, ref, other) { other }
        add_method 'to-s', ->(vm, ref) { vm.get_class("String").dagon_new(vm, "false") }
        add_method 'inspect', ->(vm, ref) { ref.inspect }
      end
    end
  end
end
