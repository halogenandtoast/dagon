module Dagon
  module Core
    class DG_Class
      attr_reader :name, :class_methods, :parent
      def initialize name = nil, parent = nil
        @constants = {}
        @methods = {
          class: ->(vm, ref) { ref.klass },
          inspect: ->(vm, ref, *args) { vm.string("#<#{name}>") },
          methods: ->(vm, ref, *args) { vm.array(@methods.map {|name, block| vm.method(ref, name, block.to_proc) }) },
          method: ->(vm, ref, *args) { vm.method(ref, args[0].value.to_sym, @methods.fetch(args[0].value.to_sym) { vm.error("ArgumentError", "No method #{args[0].value}") }) },
          init: ->(vm, ref, *args) { Dtrue },
          exit: ->(vm, ref, *args) { exit(0) },
          puts: ->(vm, ref, *args) { vm.dg_const_get("STDOUT").dagon_send(vm, "puts", *args) },
          print: ->(vm, ref, *args) { print(*args.map(&:to_s)); Dtrue },
          gets: ->(vm, ref, *args) { vm.string($stdin.gets) },
          system: ->(vm, ref, *args) { vm.string(Kernel.send(:`, *args.map(&:to_s))) },
          trap: ->(vm, ref, *args) { trap(args[0].to_s) { args[1].call(vm) } },
          self: ->(vm, ref) { ref },
          :"binding-eval" => ->(vm, ref, code, dg_binding) {
            if code.value.strip == ""
              vm.error "ArgumentError", "Can not eval an empty line"
            end
            tokens = Dagon::Scanner.tokenize(code.value, '(eval)') do |error|
              vm.error("SyntaxError", error)
              return
            end
            tree = Dagon::Parser.parse(tokens, '(eval)', false) do |error|
              vm.error("SyntaxError", error)
              return
            end
            vm.frame_eval dg_binding.frame do
              tree.evaluate(vm)
            end
          },
          eval: ->(vm, ref, code) {
            locals = vm.frame.local_variables
            frame = Frame.new(ref, "(eval)", locals)
            dg_binding = vm.from_native("Binding", frame)
            @methods[:"binding-eval"].call(vm, ref, code, dg_binding)
          },
          load: ->(vm, ref, *args) {
            filename = args[0]
            if vm.loaded? filename
              Dfalse
            else
              vm.load_file filename
              Dtrue
            end
          },
          require: ->(vm, ref, *args) {
            filename = vm.string("#{args[0]}.dg")
            @methods[:load].call(vm, ref, filename)
          },
          :"require-ext" => ->(vm, ref, *args) {
            filename = args[0]
            vm.load_paths.each do |path|
              file = File.join(path, "ext", filename.value)
              if File.exists?("#{file}.rb")
                status = require(file)
                if status
                  send("init_#{filename}".to_sym, vm)
                end
                return status
              end
            end
            vm.dg_const_get("STDERR").io.puts("Could not load #{filename}")
            exit(1)
          }
        }
        @class_ivars = {}
        @class_methods = {
          methods: ->(vm, ref) {
            vm.array(ref.class_methods.keys)
          },
          inspect: ->(vm, ref) {
            ref.name
          },
          superclass: ->(vm, ref) {
            ref.parent
          },
          class: ->(vm, ref) {
            vm.get_class("Class")
          }
        }
        @class_methods["=".to_sym] = ->(vm, ref, other_class) {
          ref == other_class ? Dtrue : Dfalse
        }
        @name = name || "Class"
        @parent = parent || self
        boot
      end

      def dagon_new(vm, *args)
        obj = dagon_allocate
        obj.dagon_send(vm, "init", *args)
        obj
      end

      def boot
        # noop
      end

      def dagon_const_get constant
        @constants[constant.to_sym]
      end

      def dagon_const_set constant, value
        @constants[constant.to_sym] = value
      end

      def add_class_method name, block
        @class_methods[name.to_sym] = block
      end

      def add_method name, block
        @methods[name.to_sym] = block
      end

      def get_method name
        @methods[name.to_sym]
      end

      def dagon_allocate
        DG_Object.new(self)
      end

      def dagon_send interpreter, name, *args
        method = @class_methods[name.to_sym]
        if method
          method.call(interpreter, self, *args)
        elsif @parent != self
          @parent.dagon_send(interpreter, name, *args)
        else
          interpreter.error("NoMethodError", "undefined method #{name} for #{to_s}")
        end
      end

      def to_s
        @name
      end
    end
  end
end
