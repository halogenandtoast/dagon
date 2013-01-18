require 'singleton'

module Dagon
  class DFalse < DObject
    include Singleton
  end
  class DTrue < DObject
    include Singleton
  end
end
