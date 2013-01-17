module Dagon
  class Call < Node
    def run
      if next_node != :call
        error "Invalid call"
      end

      identifier = Identifier.new(next_node, binding)
      args = next_node[1].map { |node| Expression.new(node, binding).reduce }
      method = identifier.lookup
      method.invoke(*args)
    end

  end
end
