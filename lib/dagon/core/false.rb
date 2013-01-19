require 'singleton'

module Dagon
  module Core
    class False < Dagon::Core::Object
      include Singleton
      def initialize
        @value = false
      end
    end
  end
end
