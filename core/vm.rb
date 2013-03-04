CORE = %w(object class array block false float frame integer string true void hash io file error)
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
        @arguments = []
        boot_core
      end

      def boot_core
        add_class("Class", DG_Class.new)
        add_class("Array", DG_ArrayClass.new)
        add_class("Block", DG_BlockClass.new)
        add_class("Error", DG_ErrorClass.new)
        add_class("False", DG_FalseClass.new)
        add_class("Float", DG_FloatClass.new)
        add_class("Hash", DG_HashClass.new)
        add_class("Integer", DG_IntegerClass.new)
        add_class("String", DG_StringClass.new)
        add_class("True", DG_TrueClass.new)
        add_class("Void", DG_VoidClass.new)

        dg_const_set("ARGV", get_class("Array").dagon_new(self, []))

        add_class("IO", DG_IOClass.new)
        add_class("File", DG_FileClass.new(self))

        stdin = get_class("IO").dagon_new(self, get_class("Integer").instance(STDIN.fileno))
        stdout = get_class("IO").dagon_new(self, get_class("Integer").instance(STDOUT.fileno))
        stderr = get_class("IO").dagon_new(self, get_class("Integer").instance(STDERR.fileno))

        dg_const_set("STDIN", stdin)
        dg_global_set("$stdin", stdin)

        dg_const_set("STDOUT", stdout)
        dg_global_set("$stdout", stdout)

        dg_const_set("STDERR", stderr)
        dg_global_set("$stderr", stderr)


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

      def set_arguments arguments
        values = arguments.map { |arg| get_class("String").dagon_new(self, arg) }
        dg_const_set("ARGV", get_class("Array").dagon_new(self, values))
      end

      def frame_eval current_frame, &block
        push_frame current_frame
        result = block.call
        if frame == current_frame
          pop_frame
        end
        result
      end

      def current_object
        @stack[0].object
      end

      def dg_const_set(name, value)
        current_object.dagon_const_set(name, value)
      end

      def dg_global_set(name, value)
        @globals[name] = value
      end

      def dg_global_get(name)
        @globals[name]
      end

      def add_class name, klass
        dg_const_set(name, klass)
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
        frame.pop
        @stack.pop
        @object = if frame
                    frame.object
                  else
                    nil
                  end
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

      def load_file dstring_filename
        self.load_dg(dstring_filename.value)
      end

      def load_dg file
        path = find_file_path(file)
        if path
          @required_files << path
          program = File.read(path)
          tokens = Dagon::Scanner.tokenize(program, file)
          tree = Dagon::Parser.parse(tokens, file, false)
          tree.evaluate(self)
          Dtrue
        else
          error "No such file or directory - #{file}\n" +
          "Searched: \n" +
          @load_paths.map{ |path| " #{path}"}.join("\n")
        end
      end

      def loaded? filename
        @required_files.include? filename
      end

      def can_rescue?(error_instance)
        frame.can_rescue?(error_instance.klass)
      end

      def dg_raise(error)
        until frame == nil || can_rescue?(error)
          pop_frame
        end
        if frame == nil
          dg_global_get("$stderr").dagon_send(self, "puts", error.message)
        else
          frame.rescue_from(self, error)
        end
      end

      def add_error_to_catch(error, block)
        frame.add_error_to_catch(error, block)
      end

      def error message
        $stderr.puts message
        exit(1)
      end
    end
  end
end

