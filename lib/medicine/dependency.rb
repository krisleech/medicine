module Medicine
  NoDefaultError = Class.new(StandardError)

  class Dependency
    attr_reader :name

    def initialize(name, options = {})
      @name    = name
      @default = options[:default]
    end

    def method_name
      name
    end

    def default
      raise NoDefaultError unless default?
      typecast(@default)
    end

    def default?
      !!@default
    end

    def required?
      !@default
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
