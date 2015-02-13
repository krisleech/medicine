# @api private

module Medicine
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

  class Dependency
    class NoDefault
      def nil?; true; end
      def present?; false; end
      def to_s; 'no default'; end
    end

    attr_reader :name

    def initialize(name, options = {})
      @name    = name
      @default = options.fetch(:default, NoDefault.new)
    end

    # FIXME: remove and assert name can be a method name
    def method_name
      name
    end

    def default
      typecast(@default)
    end

    def default?
      !@default.nil?
    end

    private

    def typecast(dependency)
      case dependency.class.name
      when 'String' then
        Inflecto.constantize(Inflecto.camelize(dependency))
      when 'Symbol' then
        typecast(dependency.to_s)
      when 'Proc' then
        dependency.call
      else
        dependency
      end
    end
  end
end
