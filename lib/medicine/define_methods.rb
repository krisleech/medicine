require "medicine/injections"

module Medicine
  class DefineMethods
    def self.on(object, injections)
      new(object, injections).call
    end

    def initialize(object, args)
      @object       = object
      @dependencies = object.class.dependencies
      @injections   = Injections.new(last_hash(args))
    end

    def call
      assert_all_dependencies_met
      object.instance_variable_set("@injections", injections)
      dependencies.each do |dependency|
        object.define_singleton_method dependency.method_name do
          @injections.fetch(dependency.name) { dependency.default }
        end
        object.singleton_class.class_eval { private dependency.method_name }
      end
    end

    private

    attr_reader :object, :dependencies, :injections

    def assert_all_dependencies_met
      raise RequiredDependencyError, "pass all required dependencies (#{unmet_dependencies.join(', ')}) in to initialize" unless unmet_dependencies.empty?
    end

    def unmet_dependencies
      dependencies.without_default.select do |dependency|
        !injections.include?(dependency.name)
      end
    end

    def last_hash(args)
      args.last.respond_to?(:[]) ? args.pop : {}
    end
  end
end
