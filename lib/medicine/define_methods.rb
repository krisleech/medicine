require "medicine/injections"

module Medicine

  # @api private

  class DefineMethods
    def self.on(object, injections)
      new(object, injections).call
    end

    def initialize(object, args)
      @object       = object
      @dependencies = object.class.dependencies
      @initializer_injections = (last_hash(args))
    end

    # define method for each dependency
    def call
      set_injections
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

    def set_injections
      @initializer_injections.each do |name, dependency|
        injections.set(name, dependency)
      end
    end

    def injections
      object.instance_variable_get("@injections")
    end

    def last_hash(args)
      args.last.respond_to?(:[]) ? args.pop : {}
    end
  end
end
