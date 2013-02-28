module Dagon
  module Core
    class DG_File < DG_IO
    end

    class DG_FileClass < DG_IOClass
      def initialize vm
        super("File", vm.get_class("IO"))
      end

      def boot
        super
        add_class_method "dirname", ->(vm, ref, file_path) {
          vm.get_class("String").dagon_new(vm, File.dirname(file_path.value))
        }
        add_class_method "join", ->(vm, ref, *paths) {
          vm.get_class("String").dagon_new(vm, File.join(paths.map(&:value)))
        }
      end

      def dagon_new interpreter, name, mode
        descriptor = File.open(name.value, mode.value)
        DG_File.new(descriptor, self)
      end
    end
  end
end
