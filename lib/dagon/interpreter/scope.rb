module Dagon
  class DScope
    attr_reader :defines
    def initialize defines = {}, parent_scope = NullBinding.new
      @parent_scope = parent_scope
      @defines = defines
    end

    def error string
      $stderr.puts string
      exit
    end

    def lookup name
      defines.fetch(name) { @parent_scope.lookup(name) }
    end

    def define name, value
      defines[name] = value
    end

    def to_s
      defines.keys.inspect
    end
  end

  class NullBinding
    def lookup name
      error("Undefined variable or method #{name}")
    end
    def error string
      $stderr.puts string
      exit
    end
  end
end
