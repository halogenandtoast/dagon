module Dagon
  module Core
    class DG_Class
      attr_reader :name, :class_methods, :parent
      def initialize name = nil, parent = nil
        @constants = {}
        @methods = {
          inspect: ->(vm, ref, *args) { vm.string("#<#{name}>") },
          methods: ->(vm, ref, *args) { vm.get_class("Array").dagon_new(vm, @methods.keys) },
          init: ->(vm, ref, *args) { },
          exit: ->(vm, ref, *args) { exit(0) },
          puts: ->(vm, ref, *args) { vm.dg_const_get("STDOUT").dagon_send(vm, "puts", *args) },
          print: ->(vm, ref, *args) { print *args.map(&:to_s) },
          gets: ->(vm, ref, *args) { vm.get_class("String").dagon_new(vm, $stdin.gets) },
          system: ->(vm, ref, *args) { vm.get_class("String").dagon_new(vm, Kernel.send(:`, *args.map(&:to_s))) },
          eval: ->(vm, ref, *args) {
            tokens = Dagon::Scanner.tokenize(args[0].value, '(eval)') do |error|
              vm.error("SyntaxError", error)
              return
            end
            tree = Dagon::Parser.parse(tokens, '(eval)', false) do |error|
              vm.error("SyntaxError", error)
              return
            end
            vm.top_level_eval do
              tree.evaluate(vm)
            end
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
            filename = vm.get_class("String").dagon_new(vm, "#{args[0]}.dg")
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
            vm.get_class("Array").dagon_new(vm, ref.class_methods.keys)
          },
          superclass: ->(vm, ref) {
            vm.get_class(ref.parent.name)
          },
          inspect: ->(vm, ref) {
            ref.name
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
          method.call(interpreter, self, *args) || Dvoid
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
