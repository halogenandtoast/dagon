module Dagon
  class Binding
    def error string
      $stderr.puts string
      exit
    end
  end

  class Environment < Binding
    attr_reader :methods
    def initialize
      @defines = {
        puts: Dagon::Method.new('puts') { |*args| puts *args },
        print: Dagon::Method.new('print') { |*args| print *args },
      }
    end

    def lookup name
      @defines[name]
    end

    def define name, value
      @defines[name] = value
    end
  end

  class Interpreter
    def initialize ast
      @ast = ast
    end

    def run
      binding = Environment.new
      program = Program.new(@ast, binding)
      program.run
    end
  end

  class Node
    attr_reader :binding, :ast
    def initialize ast, binding
      @ast = ast
      @binding = binding
    end

    def next_node
      ast.shift
    end

    def error string
      binding.error string
    end
  end

  class Program < Node
    def run
      if next_node != :program
        error "Invalid program"
      end

      statements = next_node

      statements.each do |node|
        case node[0]
        when :call
          call = Call.new(node, binding)
          call.run
        when :assignment
          name = Identifier.new(node[1], binding).to_sym
          value = Expression.new(node[2], binding).reduce
          assignment = Assignment.new(name, value, binding)
          assignment.define
        else
          error "Invalid statement #{node}"
        end
      end
    end
  end

  class Call < Node
    def run
      if next_node != :call
        error "Invalid call"
      end

      identifier = Identifier.new(next_node, binding)
      expression = Expression.new(next_node, binding)
      method = identifier.lookup
      method.invoke(expression.reduce)
    end

  end

  class Identifier < Node
    def initialize ast, binding
      super
      parse
    end
    def lookup
      binding.lookup(to_sym)
    end
    def parse
      if (node = next_node) != :identifier
        error "Invalid identifier #{node}"
      end
      @name = next_node
    end
    def to_sym
      @name.to_sym
    end
  end

  class Expression < Node
    def reduce
      type = next_node
      value = next_node
      case type
      when :identifier
        Identifier.new([type, value], binding).lookup
      when :integer
        DInteger.new(value)
      when :addition
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:+, lhs, rhs).reduce
      when :subtraction
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:-, lhs, rhs).reduce
      when :multiplication
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:*, lhs, rhs).reduce
      when :division
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:/, lhs, rhs).reduce
      else
        error "Unknown type: #{type}"
      end
    end
  end

  class Operation
    def initialize operator, lhs, rhs
      @operator = operator
      @lhs, @rhs = lhs, rhs
    end

    def reduce
      @lhs.send(@operator, @rhs)
    end
  end

  class Assignment
    def initialize name, value, binding
      @name = name
      @value = value
      @binding = binding
    end

    def define
      @binding.define(@name, @value)
    end
  end

  class Method
    def initialize name, &block
      @name = name
      @block = block
    end

    def invoke *args
      @block.call(*args)
    end
  end

  class DObject
    attr_reader :value
    def initialize value
      @value = value
    end
  end

  class DInteger < DObject
    def + object
      value + object.value
    end

    def - object
      value - object.value
    end

    def * object
      value * object.value
    end

    def / object
      value / object.value
    end
  end
end
