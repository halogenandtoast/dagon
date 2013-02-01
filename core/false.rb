require 'singleton'

module Dagon
  module Core
    class False
      include Singleton

      def inspect
        "false"
      end
    end
  end
end
