module Dagon
  module Core
    class DG_Binding < DG_Object
      attr_reader :frame
      def initialize(frame, klass)
        @frame = frame
        @klass = klass
      end

      def inspect
        "<binding#{@frame.name}>"
      end

      def to_s
        inspect
      end
    end

    class DG_BindingClass < DG_Class
      def initialize
        super("Binding", Dagon::Core::DG_Class.new)
      end

      def boot
      end

      def dagon_new vm, frame
        DG_Binding.new(frame, self)
      end
    end
  end
end
