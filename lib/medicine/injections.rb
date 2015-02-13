module Medicine
  class Injections
    def initialize(injections)
      @injections = injections.freeze
      freeze
    end

    def fetch(name, &block)
      @injections.fetch(name, &block)
    end

    def include?(name)
      @injections.has_key?(name)
    end
  end
end
