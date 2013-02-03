module Dagon
  module Core
    class DG_Hash < DG_Object
      attr_reader :hash
      def initialize(assignments, klass)
        @hash = convert_assignments_to_hash_values(assignments)
        @klass = klass
      end

      def to_s
        hash
      end

      def inspect
        hash.inspect
      end

      private

      def convert_assignments_to_hash_values(assignments)
        hash = {}
        assignments.each do |assignment|
          hash[assignment.variable_name] = assignment.variable_value
        end
        hash
      end
    end

    class DG_HashClass < DG_Class
      def initialize
        super("Hash", DG_Class.new)
        boot
      end

      def boot

        add_method "=", ->(vm, ref, other) do
          ref.hash == other.hash ? Dtrue : Dfalse
        end

        add_method "!=", ->(vm, ref, other) do
          ref.hash != other.hash ? Dtrue : Dfalse
        end
      end

      def dagon_new interpreter, assignments
        DG_Hash.new(assignments, self)
      end
    end
  end
end
