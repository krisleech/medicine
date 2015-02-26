require "inflecto"
require "medicine/dependency"

module Medicine

  # @api private

  class Dependencies
    include Enumerable

    def initialize
      @dependencies = []
    end

    def all
      @dependencies
    end

    def each(&block)
      all.each(&block)
    end

    def empty?
      all.empty?
    end

    def size
      all.size
    end

    def <<(dependency)
      push(dependency)
    end

    def add(name, options = {})
      push(Dependency.new(name, options))
    end

    def push(dependency)
      all.push(dependency)
    end

    def without_default
      reject(&:default?)
    end
  end
end
