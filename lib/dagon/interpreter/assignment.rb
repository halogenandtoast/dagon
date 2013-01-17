module Dagon
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

end
