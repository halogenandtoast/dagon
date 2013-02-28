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
      end

      def dagon_new interpreter, name, mode
        descriptor = File.open(name.value, mode.value)
        DG_File.new(descriptor, self)
      end
    end
  end
end
