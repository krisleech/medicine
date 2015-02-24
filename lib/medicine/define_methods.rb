require "medicine/injections"

module Medicine

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
        @injections.get(dependency.name) { dependency.default }
      end
      object.singleton_class.class_eval { private dependency.method_name }
    end

    def injections
      object.instance_variable_get("@injections")
    end
  end
end
