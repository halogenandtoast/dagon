module Dagon
  class Binding
    def error string
      $stderr.puts string
      exit
    end
  end
end
