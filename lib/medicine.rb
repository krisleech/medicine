require "medicine/version"
require "medicine/dependencies"
require "inflecto"

module Medicine
  def self.di
    DI
  end

  RequiredDependencyError = Class.new(::ArgumentError)

  module DI
    def self.included(base)
      base.extend(ClassMethods)
    end

    def self.prepended(base)
      base.extend(ClassMethods)
    end

    def initialize(*args)
      @dependencies = extract_dependencies(args)
      assert_all_dependencies_met
      define_dependency_methods

      super
    end

    private

    def define_dependency_methods
      self.class.dependencies.each do |dependency|
        define_singleton_method dependency.method_name do
          @dependencies.fetch(dependency.name) { dependency.default }
        end
        self.singleton_class.class_eval { private dependency.method_name }
      end
    end

    def extract_dependencies(args)
      args.last.respond_to?(:[]) ? args.pop : {}
    end

    def assert_all_dependencies_met
      raise RequiredDependencyError, "pass all required dependencies (#{unmet_dependencies.join(', ')}) in to initialize" unless unmet_dependencies.empty?
    end

    def unmet_dependencies
      self.class.dependencies.without_default.select do |dependency|
        !@dependencies.has_key?(dependency.name)
      end
    end

    module ClassMethods
      def dependencies
        @dependencies ||= Dependencies.new
      end

      private

      # macro to declare a dependency
      #
      # @example
      #   class MyThing
      #     depdendency :user_repo, default: -> { User }
      #   end
      def dependency(name, options = {})
        dependencies.add(name, options)
      end

      def inherited(subclass)
        subclass.instance_variable_set("@dependencies", @dependencies)
        super
      end
    end
  end
end
