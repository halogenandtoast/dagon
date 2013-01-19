require 'singleton'

module Dagon
  module Core
    class True < Dagon::Core::Object
      include Singleton
      def initialize
        @value = true
      end
    end
  end
end
