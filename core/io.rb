module Dagon
  module Core
    class DG_IO < DG_Object
      attr_reader :file_descriptor
      def initialize file_descriptor, klass
        @file_descriptor = file_descriptor
        @klass = klass
      end

      def to_s
        "#<IO>"
      end
    end

    class DG_IOClass < DG_Class
      def initialize name = "IO", klass = Dagon::Core::DG_Class.new
        super(name, klass)
      end

      def boot
        add_method "init", ->(vm, ref, file_descriptor) {
          ref.instance_variable_set("@file_descriptor", file_descriptor)
        }
        add_method "read", ->(vm, ref) {
          vm.get_class("String").dagon_new(vm, ref.file_descriptor.read)
        }
      end

      def dagon_new interpreter, value
        DG_IO.new(value, self)
      end
    end
  end
end
