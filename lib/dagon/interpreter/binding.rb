module Dagon
  class Binding
    def error string
      $stderr.puts string
      exit
    end

    def lookup name
      @defines[name]
    end

    def define name, value
      @defines[name] = value
    end
  end
end
