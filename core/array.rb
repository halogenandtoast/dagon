module Dagon
  module Core
    class DG_Array < DG_Object
      attr_reader :value
      def initialize value, klass
        @value = value
        @klass = klass
      end

      def to_s
        '['+@value.map(&:inspect).join(', ')+']'
      end

      def inspect
        to_s
      end
    end

    class DG_ArrayClass < DG_Class
      def initialize
        super('Array', Dagon::Core::DG_Class.new)
      end

      def boot
        add_method 'init', ->(vm, ref, value) {
          ref.instance_variable_set('@value', value)
        }
        add_compiled_methods("array.rb", <<-DEF)
          [](index):
            DAGONVM.aref(self, index)
          []:(index, value):
            DAGONVM.aref-set(self, index, value)
          +(other):
            new: []
            offset: length
            0.upto(length - 1) ->(i)
              new[i]: self[i]
            0.upto(other.length - 1) ->(i)
              new[i + offset]: other[i]
            new
          -(other):
            new: []
            0.upto(length - 1) ->(i)
              include: true
              0.upto(other.length - 1) ->(j)
                test: other[j] != self[i]
                include: include && test
              if include
                new[new.length]: self[i]
              else
                true
            new
          =(other):
            if other.length = length
              truth: true
              0.upto(length - 1) ->(i)
                truth: truth && self[i] = other[i]
              truth
            else
              false
          push(value):
            self[length]: value
            self
          last:
            self[length - 1]
          join(glue):
            if length = 0
              ""
            elseif length = 1
              self[0]
            else
              str: self[0].to-s
              1.upto(length - 1) ->(i)
                str: str + glue + self[i].to-s
              str
          empty?:
            length = 0
          any?:
            length != 0
          reduce(initial, block):
            value: initial
            0.upto(length - 1) ->(i)
              value: block.call(value, self[i])
            value
          map(block):
            new: []
            0.upto(length - 1) ->(i)
              new[i]: block.call(self[i])
            new
          *(times):
            new: []
            1.upto(times) ->(i)
              0.upto(length - 1) ->(j)
                new[new.length]: self[j]
            new
        DEF
        add_method 'pop', ->(vm, ref) {
          ref.value.pop
        }
        add_method 'unshift', ->(vm, ref, object) {
          ref.value.unshift(object)
        }
        add_method 'shift', ->(vm, ref) {
          ref.value.shift
        }
        add_method 'length', ->(vm, ref) {
          vm.int(ref.value.length)
        }
        add_method 'inspect', ->(vm, ref) {
          vm.string(ref.inspect)
        }
      end

      def dagon_new interpreter, value = []
        if value.is_a? DG_Array
          DG_Array.new(value.value, self)
        else
          DG_Array.new(value, self)
        end
      end
    end
  end
end
