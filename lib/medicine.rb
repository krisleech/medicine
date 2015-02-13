require "medicine/version"
require "medicine/dependencies"
require "medicine/injections"
require "medicine/define_methods"
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
      DefineMethods.on(self, args)
      super
    end

    private

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
