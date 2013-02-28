module Dagon
  module Core
    class DG_IO < DG_Object
      attr_reader :fd
      def initialize fd, klass
        @fd = fd
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
        add_method "init", ->(vm, ref, fd) {
          ref.instance_variable_set("@fd", fd)
        }
        add_method "read", ->(vm, ref) {
          vm.get_class("String").dagon_new(vm, ref.fd.read)
        }
      end

      def dagon_new interpreter, value
        DG_IO.new(value, self)
      end
    end
  end
end
