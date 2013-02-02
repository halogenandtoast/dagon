require "core/object"
require "core/frame"
require "core/true"
require "core/false"
require "core/void"

Dtrue = Dagon::Core::True.instance
Dfalse = Dagon::Core::False.instance
Dvoid = Dagon::Core::Void.instance

require "pry"

module Dagon
  module Core
    class VM
      attr_reader :globals
      def initialize main = nil
        @load_paths = [File.expand_path(".")]
        @required_files = []
        @object = main || Dagon::Core::DG_Object.new
        @stack = []
        @stack.push Frame.new(@object, '(toplevel)')
        @globals = {}
      end

      def add_load_path path
        unless @load_paths.include? path
          @load_paths << path
        end
      end

      def frame
        @stack.last
      end

      def push_frame frame
        @stack.push frame
        @object = frame.object
      end

      def pop_frame
        @stack.pop
        @object = frame.object
      end

      def dagon_define_class name, parent
        @object.dagon_define_class name, parent
      end

      def define_function name, block
        if @object.respond_to? :add_method
          @object.add_method name, block
        else
          @object.klass.add_method name, block
        end
      end

      def find_file_path filename
        @load_paths.each do |path|
          if File.exists? File.join(path, "#{filename}.dg")
            return File.join(path, "#{filename}.dg")
          end
        end
        nil
      end

      def load_file filename
        path = find_file_path(filename.value)
        if path
          @required_files << path
          program = File.read(path)
          tokens = Dagon::Scanner.tokenize(program, filename)
          tree = Dagon::Parser.parse(tokens, filename, false)
          tree.evaluate(self)
          Dtrue
        else
          error "No such file or directory - #{filename.value}\n" +
          "Searched: \n" + 
          @load_paths.map{ |path| " #{path}"}.join("\n")
        end
      end

      def loaded? filename
        @required_files.include? filename
      end

      def error message
        $stderr.puts message
        exit(1)
      end
    end
  end
end

