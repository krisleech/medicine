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

    # returns the default, yields block or raises an error
    #
    # FIXME: move block yielding to default_or method.
    def default
      if default?
        typecast(@default)
      else
        if block_given?
          yield
        else
          raise NoDefaultError, "No default declared for #{name}"
        end
      end
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
