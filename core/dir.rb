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
        add_class_method "glob", ->(vm, ref, glob_path) {
          paths = Dir.glob(glob_path.value).map { |path| vm.get_class("String").dagon_new(vm, path) }
          vm.get_class("Array").dagon_new(vm, paths)
        }
      end
    end
  end
end
