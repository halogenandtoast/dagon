module Dagon
  class Environment < Binding
    attr_reader :methods
    def initialize
      @defines = {
        puts: Dagon::Method.new('puts') { |*args| puts *args.map(&:value) },
        print: Dagon::Method.new('print') { |*args| print *args.map(&:value) },
      }
    end

    def lookup name
      @defines[name]
    end

    def define name, value
      @defines[name] = value
    end
  end
end
