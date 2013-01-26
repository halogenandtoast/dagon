require 'singleton'

module Dagon
  module Core
    class Void < Dagon::Core::Object
      include Singleton
      def initialize
        super(nil)
      end

      def equal object
        binding.pry
        if object.value == nil
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end
    end
  end
end
