module Dagon
  module Core
    class DG_DirClass < DG_Class
      def initialize
        super("Dir", Dagon::Core::DG_Class.new)
      end

      def boot
        add_class_method "getwd", ->(vm, ref) {
          vm.get_class("String").dagon_new(vm, Dir.getwd)
        }
      end
    end
  end
end
