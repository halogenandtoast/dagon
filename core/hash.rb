module Dagon
  module Core
    class DG_Hash < DG_Object
      attr_reader :hash
      def initialize(hash, klass)
        @hash = hash
        @klass = klass
      end

      def to_s
        hash
      end

      def inspect
        "{ " + key_value_pairs.join(", ") + " } "
      end

      private

      def key_value_pairs
        hash.map do |key, value|
          "#{key.to_s}: #{value.inspect}"
        end
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
        add_method 'inspect', ->(vm, ref) do
          ref.inspect
        end
      end

      def dagon_new interpreter, hash
        DG_Hash.new(hash, self)
      end
    end
  end
end
