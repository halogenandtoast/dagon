module Dagon
  class Environment
    def initialize
      @defines = {
        puts: Dagon::Method.new('puts') { |*args| puts args.map(&:to_s) },
        print: Dagon::Method.new('print') { |*args| print args.map(&:to_s) },
      }
    end

    def binding
      DBinding.new(@defines)
    end
  end
end
