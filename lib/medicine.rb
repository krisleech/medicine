require "medicine/version"
require "medicine/dependencies"
require "medicine/define_methods"

module Medicine
  def self.di
    DI
  end

  RequiredDependencyError = Class.new(::ArgumentError)

  module DI

    # pass injections as a hash
    #
    # @example
    #   new(user_repo: User, role_repo: Role)
    def initialize(*args)
      DefineMethods.on(self, args)
      super
    end

    private

    def self.included(base)
      base.extend(ClassMethods)
    end

    def self.prepended(base)
      base.extend(ClassMethods)
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

    private_constant :ClassMethods
  end
end
