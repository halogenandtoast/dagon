CORE = %w(object class array block false float frame integer string true void)
CORE.each do |klass|
  require "core/#{klass}"
end

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
        @classes = {}
        boot_core
      end

      def boot_core
        current_object.dagon_const_set("Array", DG_ArrayClass.new)
        current_object.dagon_const_set("Block", DG_BlockClass.new)
        current_object.dagon_const_set("False", DG_FalseClass.new)
        current_object.dagon_const_set("Float", DG_FloatClass.new)
        current_object.dagon_const_set("Integer", DG_IntegerClass.new)
        current_object.dagon_const_set("String", DG_StringClass.new)
        current_object.dagon_const_set("True", DG_TrueClass.new)
        current_object.dagon_const_set("Void", DG_VoidClass.new)

        unless Kernel.const_defined?("Dtrue")
          Kernel.const_set("Dtrue", Dagon::Core::True.instance)
        end
        unless Kernel.const_defined?("Dfalse")
          Kernel.const_set("Dfalse", Dagon::Core::False.instance)
        end
        unless Kernel.const_defined?("Dvoid")
          Kernel.const_set("Dvoid", Dagon::Core::Void.instance)
        end
      end

      def current_object
        @stack[0].object
      end

      def add_class name, object
        current_object.dagon_const_set(name, object)
      end

      def get_class name
        current_object.dagon_const_get(name)
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

