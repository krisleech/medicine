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

    # pass injections as a hash
    #
    # @example
    #   new(user_repo: User, role_repo: Role)
    def initialize(*args)
      extract_injections(args)
      assert_all_dependencies_met
      define_dependency_methods
      super
    end

    private

    def extract_injections(args)
      @injections = args.last.respond_to?(:[]) ? args.pop : {}
    end

    def assert_all_dependencies_met
      raise RequiredDependencyError, "pass all required dependencies (#{unmet_dependencies.join(', ')}) in to initialize" unless unmet_dependencies.empty?
    end

    def define_dependency_methods
      dependencies.each do |dependency|
        define_singleton_method dependency.method_name do
          @injections.fetch(dependency.name) { dependency.default }
        end
        self.singleton_class.class_eval { private dependency.method_name }
      end
    end

    def unmet_dependencies
      dependencies.without_default.select do |dependency|
        !@injections.has_key?(dependency.name)
      end
    end

    def dependencies
      self.class.dependencies
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
