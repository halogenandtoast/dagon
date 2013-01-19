require 'singleton'

module Dagon
  class DFalse < DObject
    include Singleton

    def self._if(_)
    end

    @value = false
  end
  class DTrue < DObject
    include Singleton

    def self._if(block)
      block.invoke
    end

    @value = true
  end
end
