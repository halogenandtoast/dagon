require 'readline'

class DG_ReadlineClass < Dagon::Core::DG_Class
  def initialize
    super('Readline', Dagon::Core::DG_Class.new)
  end

  def boot
    add_class_method "readline", ->(vm, ref, prompt, add_history) {
      string = Readline.readline(prompt.value, add_history == Dfalse ? false : true)
      vm.get_class("String").dagon_new(vm, string)
    }
  end
end

def init_readline(vm)
  vm.add_class("Readline", DG_ReadlineClass.new)
end
