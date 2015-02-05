require "isopod/version"

module Isopod
  def self.di
    DI
  end

  module DI
    ArgumentError = Class.new(::ArgumentError)

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(*args)
      @dependencies = extract_dependencies(args)
      assert_all_dependencies_met
      define_dependency_methods

      super(*args)
    end

    private

    def define_dependency_methods
      self.class.dependencies.each do |name, options|
        define_singleton_method name do
          @dependencies.fetch(name) { resolve_dependency(name) }
        end
      end
    end

    def extract_dependencies(args)
      args.last.respond_to?(:[]) ? args.pop : {}
    end

    def assert_all_dependencies_met
      raise ArgumentError, "initalize with all dependencies without a default" unless all_dependencies_met?
    end

    def all_dependencies_met?
      self.class.dependencies.keys.all? do |key|
        @dependencies.has_key?(key) || self.class.dependencies.fetch(key).has_key?(:default)
      end
    end

    def resolve_dependency(name)
      self.class.dependencies.fetch(name).fetch(:default)
    end

    module ClassMethods
      def dependency(name, options = {})
        dependencies[name] = options
      end

      def dependencies
        @dependencies ||= {}
      end
    end
  end
end
