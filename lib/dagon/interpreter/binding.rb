module Dagon
  class DBinding
    attr_reader :defines
    def initialize defines = {}, child_binding = NullBinding.new
      @child_binding = child_binding
      @defines = defines
    end

    def error string
      $stderr.puts string
      exit
    end

    def lookup name
      defines.fetch(name) { @child_binding.lookup(name) }
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
