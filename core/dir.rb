module Dagon
  module Core
    # Represents directories in the file system, and provides methods for
    # interacting with with.
    class DG_DirClass < DG_Class
      def initialize
        super("Dir", Dagon::Core::DG_Class.new)
      end

      def boot
        # getwd → String
        #
        # Returns a String representation of the current working directory for
        # the program.
        #
        #   Dir.getwd
        #   # => "/Users/caleb/code/dagon"
        add_class_method "getwd", ->(vm, ref) {
          vm.get_class("String").dagon_new(vm, Dir.getwd)
        }

        # glob(pattern) → Array
        #
        # Returns the filenames found by expanding +pattern+ which is an +Array+ of
        # +String+.
        #
        #   Dir.glob("/*")
        #   # => ["/bin", "/etc", "/sbin", "/tmp", "/usr", "/var"]

        # * Note that this pattern is not a regexp (it’s closer to a shell glob).
        # * Note that case sensitivity depends on your system, as does the order in which the results are returned.
        add_class_method "glob", ->(vm, ref, glob_path) {
          paths = Dir.glob(glob_path.value).map { |path| vm.get_class("String").dagon_new(vm, path) }
          vm.get_class("Array").dagon_new(vm, paths)
        }
      end
    end
  end
end
