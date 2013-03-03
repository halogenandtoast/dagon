module Dagon
  module Core
    class DG_IO < DG_Object
      attr_reader :file_descriptor, :io
      def initialize file_descriptor, klass
        @file_descriptor = file_descriptor
        @io = IO.new(@file_descriptor.value)
        @klass = klass
      end

      def to_s
        case @file_descriptor.value
        when 0 then "#<IO:<STDIN>>"
        when 1 then "#<IO:<STDOUT>>"
        when 2 then "#<IO:<STDERR>>"
        else
          "#<IO:fd #{@file_descriptor.value}>"
        end
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
        add_method "write", ->(vm, ref, string) {
          ref.io.write(string.value)
        }
        add_method "puts", ->(vm, ref, string) {
          ref.io.puts(string.value)
        }
        add_method "close", ->(vm, ref) {
          ref.io.close
        }
        add_method "read", ->(vm, ref) {
          vm.get_class("String").dagon_new(vm, ref.io.read)
        }
        add_method "fileno", ->(vm, ref) {
          vm.get_class("Integer").instance(ref.file_descriptor.value)
        }
        add_class_method "pipe", ->(vm, ref) {
          vm.get_class("Array").dagon_new(vm, ::IO.pipe.map { |io| dagon_new(vm, vm.get_class("Integer").instance(io.fileno)) })
        }
      end

      def dagon_new interpreter, value
        DG_IO.new(value, self)
      end
    end
  end
end
