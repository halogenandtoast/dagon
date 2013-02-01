require 'singleton'

module Dagon
  module Core
    class True
      include Singleton

      def inspect
        "true"
      end
    end
  end
end
