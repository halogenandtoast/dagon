CORE = %w(object class array block false decimal frame function integer string true io file error dir method curried_method binding dagonvm)
CORE.each do |klass|
  require "core/#{klass}"
end

require "pry"

module Dagon
  module Core
    class VM
      attr_reader :globals, :top_object, :load_paths, :stack
      attr_accessor :filename, :line_number

      def initialize
        $vm = self
        setup_load_paths
        setup_top_level
        boot_core
        setup_globals_and_constants
        set_arguments(ARGV)
      end

      def setup_load_paths
        @load_paths = [File.expand_path("."), File.join(File.dirname(__FILE__), "..", "lib")]
        @required_files = []
      end

      def setup_top_level
        @stack = []
        @top_object = Dagon::Core::DG_Object.new
        @top_level_frame = Frame.new(@top_object, '(toplevel)')
        @stack.push @top_level_frame
      end

      def boot_core
        add_class("DAGONVM", DG_DAGONVMClass.new)
        dg_const_set("DAGONVM", DAGONVM.instance)

        add_class("Method", DG_MethodClass.new)
        add_class("Class", DG_Class.new)

        add_class("String", DG_StringClass.new)
        add_class("Array", DG_ArrayClass.new)
        add_class("Binding", DG_BindingClass.new)
        add_class("Block", DG_BlockClass.new)
        add_class("CurriedMethod", DG_CurriedMethodClass.new)
        add_class("Dir", DG_DirClass.new)
        add_class("Error", DG_ErrorClass.new)
        add_class("False", DG_FalseClass.new)
        add_class("Decimal", DG_DecimalClass.new)
        add_class("Function", DG_FunctionClass.new)
        load_core("hash")
        add_class("Integer", DG_IntegerClass.new)
        add_class("True", DG_TrueClass.new)

        add_class("NoMethodError", DG_NoMethodErrorClass.new)
        add_class("InternalError", DG_InternalErrorClass.new)
        add_class("ArgumentError", DG_ArgumentErrorClass.new)
        add_class("SyntaxError", DG_SyntaxErrorClass.new)
        add_class("LoadError", DG_LoadErrorClass.new)
        add_class("NameError", DG_NameErrorClass.new)
        add_class("NullReferenceError", DG_NullReferenceErrorClass.new)

        add_class("IO", DG_IOClass.new)
        add_class("File", DG_FileClass.new(self))

        unless Kernel.const_defined?("Dtrue")
          Kernel.const_set("Dtrue", Dagon::Core::True.instance)
        end

        unless Kernel.const_defined?("Dfalse")
          Kernel.const_set("Dfalse", Dagon::Core::False.instance)
        end
      end

      def setup_globals_and_constants
        @globals = {}

        stdin = from_native("IO", int(STDIN.fileno))
        stdout = from_native("IO", int(STDOUT.fileno))
        stderr = from_native("IO", int(STDERR.fileno))

        top_level_binding = from_native("Binding", @top_level_frame)

        dg_const_set("ARGV", array([]))
        dg_const_set("STDIN", stdin)
        dg_const_set("STDOUT", stdout)
        dg_const_set("STDERR", stderr)
        dg_const_set("TOP_LEVEL_BINDING", top_level_binding)

        dg_global_set("$stdin", stdin)
        dg_global_set("$stdout", stdout)
        dg_global_set("$stderr", stderr)
        dg_global_set("$LOAD_PATH", array(@load_paths))

      end

      def set_arguments arguments
        values = arguments.map { |arg| string(arg) }
        dg_const_set("ARGV", array(values))
      end

      def load_core(name)
        filename = "core/#{name}.dg"
        code = File.read(filename)
        dg_eval(filename, code)
      end

      def dg_eval(filename, code)
        tokens = Dagon::Scanner.tokenize(code, filename)
        tree = Dagon::Parser.parse(tokens, filename)
        tree.evaluate(self)
      end

      def frame_eval current_frame, &block
        push_frame current_frame
        result = block.call
        if frame == current_frame # TODO: remember why I do this
          pop_frame
        end
        result
      end

      def top_level_eval &block
        frame = @stack[0].dup
        frame_eval frame, &block
      end

      def current_object
        frame.object
      end

      def dg_const_set(name, value)
        current_object.dagon_const_set(name, value)
      end

      def dg_const_get(name)
        @stack.reverse.each do |frame|
          if const = frame.object.dagon_const_get(name)
            return const
          end
        end
        error "NameError", "uninitialized constant #{name}"
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
        @top_object.dagon_const_get(name)
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
      end

      def pop_frame
        frame.pop
        @stack.pop
      end

      def dagon_define_class name, parent
        current_object.dagon_define_class name, parent
      end

      def define_function name, block
        if current_object.respond_to? :add_method
          current_object.add_method name, block
        else
          current_object.klass.add_method name, block
        end
        method(current_object, name, block)
        # get_class("Function").dagon_new(self, current_object, name, block)
      end

      def find_file_path filename
        @load_paths.each do |path|
          file_path = File.join(path, filename)
          if File.exists? file_path
            return file_path
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
          program = string(File.read(path))
          @top_object.dagon_send(self, :eval, program)
          Dtrue
        else
          error "LoadError", "No such file or directory - #{file}\n" +
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
          dg_global_get("$stderr").dagon_send(self, "puts", error.printable_error(self))
          exit(1)
        else
          frame.rescue_from(self, error)
        end
      end

      def rescue_from_all_errors(block)
        frame.catch_all_errors(block)
      end

      def add_error_to_catch(error, block)
        frame.add_error_to_catch(error, block)
      end

      def error(klass, message)
        error = get_class(klass).dagon_new(self, message)
        dg_raise(error)
      rescue
        binding.pry
        1
      end

      def curry(dg_binding, name, function, *args)
        get_class("CurriedMethod").dagon_new(self, dg_binding, name, function, args)
      end

      def method(dg_binding, name, block)
        get_class("Method").dagon_new(self, dg_binding, name, block)
      end

      def cast(native_value)
        case native_value.class.to_s
        when "String" then string(native_value)
        when "Array" then array(native_value)
        when "Fixnum" then int(native_value)
        when "Decimal" then decimal(native_value)
        when "TrueClass", "FalseClass" then bool(native_value)
        else
          native_value
        end
      end

      def unwrap(dagon_object)
        if dagon_object.kind_of? DG_Object
          dagon_object.value
        else
          dagon_object
        end
      end

      def string(native_string)
        from_native("String", native_string)
      end

      def bool(native_bool)
        native_bool ? Dtrue : Dfalse
      end

      def array(native_array)
        from_native("Array", native_array)
      end

      def int(native_int)
        literal("Integer", native_int)
      end

      def decimal(native_decimal)
        literal("Decimal", native_decimal)
      end

      def from_native(klass, native_value)
        get_class(klass).dagon_new(self, native_value)
      end

      def literal(klass, native_value)
        get_class(klass).instance(native_value)
      end

      def notify(node)
        @filename = node.filename
        @line_number = node.line_number
      end
    end
  end
end
