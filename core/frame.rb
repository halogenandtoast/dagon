module Dagon
  module Core
    class Frame
      attr_accessor :frame_name
      attr_reader :object, :local_variables
      def initialize object, frame_name, local_variables = {}
        @object = object
        @frame_name = frame_name
        @local_variables = local_variables
        @catch_all_errors = false
        @rescue_block = nil
        @errors_to_catch = {}
        @popped = false
      end

      def pop
        @popped = true
      end

      def popped?
        @popped
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
        result = Dvoid
        if @catch_all_errors
          result = @rescue_block.dagon_send(vm, "call", error)
        else
          block = @errors_to_catch[error.klass]
          result = block.dagon_send(vm, "call", error)
        end
        pop # this is a pretty naive solution, we need something better but not sure what
        result
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
