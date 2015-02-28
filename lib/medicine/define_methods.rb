require "medicine/injections"

module Medicine

  # Exception raised when dependency not injected via initializer or inject
  # method and no default declared.
  #
  class NoInjectionError < StandardError
    def initialize(dependency)
      @dependency = dependency
    end

    def to_s
      "Dependency not injected and default not declared for #{@dependency.name}"
    end
  end

  # @api private

  class DefineMethods
    def self.on(object)
      new(object).call
    end

    def initialize(object)
      @object       = object
      @dependencies = object.class.dependencies
    end

    # define method for each dependency
    def call
      dependencies.each { |dependency| build_method(dependency) }
    end

    private

    attr_reader :object, :dependencies, :injections

    def build_method(dependency)
      object.define_singleton_method dependency.method_name do
        begin
          @injections.get(dependency.name) { dependency.default }
        rescue NoDefaultError
          raise NoInjectionError.new(dependency)
        end
      end
      object.singleton_class.class_eval { private dependency.method_name }
    end

    def injections
      object.instance_variable_get("@injections")
    end
  end
end
