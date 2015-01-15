require 'socket'

class DG_TCPSocket < Dagon::Core::DG_IO
  attr_reader :socket
  def initialize(vm, socket, klass)
    @socket = socket
    super(vm.int(@socket.fileno), klass)
  end

  def inspect
    "<TCPSocket:fd #{@file_descriptor.value}>"
  end
end

class DG_TCPSocketClass < Dagon::Core::DG_IOClass
  def initialize vm
    super('TCPSocket', vm.get_class("IO"))
  end

  def boot
    add_method "gets", ->(vm, ref) { vm.string(ref.socket.gets) }
    add_method "inspect", ->(vm, ref) { vm.string(ref.inspect) }
    add_method "puts", ->(vm, ref, string) { ref.socket.puts(string.value); Dtrue }
    add_method "close", ->(vm, ref) { ref.socket.close; Dtrue }
  end

  def dagon_new(vm, host, port)
    socket = TCPSocket.new(host.value, port.value)
    DG_TCPSocket.new(vm, socket, self)
  end
end

class DG_TCPServer < Dagon::Core::DG_IO
  attr_reader :server
  def initialize(vm, server, klass)
    @server = server
    super(vm.int(@server.fileno), klass)
  end

  def inspect
    "<TCPServer:fd #{@file_descriptor.value}>"
  end
end

class DG_TCPServerClass < Dagon::Core::DG_IOClass
  def initialize(vm)
    super('TCPServer', vm.get_class("IO"))
  end

  def boot
    add_method "accept", ->(vm, ref) { DG_TCPSocket.new(vm, ref.server.accept, vm.get_class("TCPSocket")) }
    add_method "inspect", ->(vm, ref) { vm.string(ref.inspect) }
  end

  def dagon_new(vm, port)
    server = TCPServer.new(port.value)
    DG_TCPServer.new(vm, server, self)
  end
end


def init_socket(vm)
  vm.add_class("TCPSocket", DG_TCPSocketClass.new(vm))
  vm.add_class("TCPServer", DG_TCPServerClass.new(vm))
end
