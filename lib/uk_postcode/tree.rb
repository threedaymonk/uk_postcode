module UKPostcode
  class Tree
    def initialize(tree = {})
      @root = tree
    end

    def insert(path, value)
      path[0..-2].inject(@root) { |n, p| n[p] ||= {} }[path.last] = value
    end

    def compress
      self.class.new(compress_node(@root))
    end

    def filter(leaf_value)
      self.class.new(filter_node(@root, leaf_value))
    end

    def regexp
      Regexp.new('^' + node_regexp(@root))
    end

    def to_h
      @root
    end

  private

    def leaf?(node)
      node.is_a?(Symbol)
    end

    def contains_identical_leaves?(node)
      node.values.all? { |t| leaf?(t) } && node.values.uniq.length == 1
    end

    def compress_node(node)
      if leaf?(node)
        node
      else
        comp = Hash[node.map { |k, v| [k, compress_node(v)] }]
        contains_identical_leaves?(comp) ? comp.values.first : comp
      end
    end

    def filter_node(node, leaf_value)
      if node == leaf_value
        node
      elsif leaf?(node)
        nil
      else
        h = Hash[node.map { |k, v| [k, filter_node(v, leaf_value)] }.
                 select { |_, v| v }]
        h.empty? ? nil : h
      end
    end

    def node_regexp(node)
      if leaf?(node)
        ''
      else
        segments = node.map { |k, v| k + node_regexp(v) }
        if segments.length > 1
          if segments.all? { |s| s.length == 1 }
            '[' + segments.join('') + ']'
          else
            '(?:' + segments.join('|') + ')'
          end
        else
          segments.first
        end
      end
    end
  end
end
