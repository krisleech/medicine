module Medicine

  # @api private

  class Injections
    def initialize
      @injections = {}
    end

    def get(name, &block)
      @injections.fetch(name, &block)
    rescue KeyError
      raise ArgumentError, "No dependency with name #{name} has been injected."
    end

    def [](name, &block)
      get(name, &block)
    end

    def set(name, dependency)
      @injections[name] = dependency
    end

    def include?(name)
      @injections.has_key?(name)
    end

    def empty?
      @injections.empty?
    end
  end
end
