require "inflecto"
require "medicine/dependency"

module Medicine
  UnknownDependency = Class.new(StandardError)

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

    def [](name)
      find { |dependency| dependency.name == name }
    end

    def fetch(name)
      self[name] || raise(UnknownDependency, "Dependency #{name} is unknown")
    end

    def include?(name)
      !!self[name]
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
