module Dagon
  module Core
    class Frame
      attr_reader :object, :frame_name, :local_variables
      def initialize object, frame_name, local_variables = {}
        @object = object
        @frame_name = frame_name
        @local_variables = local_variables
        @catch_all_errors = false
        @rescue_block = nil
        @errors_to_catch = {}
      end

      def local_variable? name
        @local_variables.key? name
      end

      def [](key)
        @local_variables[key]
      end

      def []=(key, value)
        @local_variables[key] = value
      end

      def can_rescue?(error_class)
        if @catch_all_errors
          true
        else
          @errors_to_catch.keys.include?(error_class)
        end
      end

      def rescue_from(vm, error)
        if @catch_all_errors
          @rescue_block.dagon_send(vm, "call", error)
        else
          block = @errors_to_catch[error.klass]
          block.evaluate(vm).dagon_send(vm, "call", error)
        end
      end

      def add_error_to_catch(error, block)
        @errors_to_catch[error] = block
      end

      def catch_all_errors(block)
        @catch_all_errors = true
        @rescue_block = block
      end
    end
  end
end
