module Dagon
  module Core
    class DG_Array < DG_Object
      attr_reader :list
      def initialize list
        @list = list
        @klass = DG_Array_Class.new
      end
    end

    class DG_Array_Class < DG_Class
      def initialize
        super("Array", Dagon::Core::DG_Class.new)
        @class_methods[:new] = ->(vm, ref, *args) { DG_Array.new(*args) }
        boot
      end

      def boot
        add_method "init", ->(vm, ref, value) {
          ref.instance_variable_set("@value", value)
        }
        add_method "[]", ->(vm, ref, index) {
          ref.list[index.value]
        }
      end
    end
  end
end
