module Dagon
  class Environment
    def initialize
      @defines = {
        puts: Dagon::Method.new('puts') { |*args| puts *args.map(&:value) },
        print: Dagon::Method.new('print') { |*args| print *args.map(&:value) },
      }
    end

    def binding
      DBinding.new(@defines)
    end
  end
end
