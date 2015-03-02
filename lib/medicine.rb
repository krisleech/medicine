require "medicine/version"
require "medicine/dependencies"
require "medicine/injections"

module Medicine
  # returns the {Medicine::DI} module
  #
  # @example
  #   class MyCommand
  #     include Medicine.di
  #   end
  #
  # @api public
  def self.di
    DI
  end

  RequiredDependencyError = Class.new(::ArgumentError)
  DependencyUnknownError  = Class.new(::StandardError)
  NoInjectionError        = Class.new(::StandardError)

  module DI
    # Injects dependencies
    #
    # @param [Array<Object>] args - the last argument must be a Hash
    #
    # @return [undefined]
    #
    # @example
    #   register_user = RegisterUser.new(user_repo: double('UserRepo'))
    #
    # @api public
    def initialize(injections = {})
      @injections = Injections.new
      injects(injections)
      super()
    end

    # Injects a dependency
    #
    # @param [Symbol] key
    # @param [Object] dependency
    #
    # @return [self]
    #
    # @example
    #   register_user.inject(:user_repo, double('UserRepo'))
    #
    # @api public
    def inject(name, dependency)
      raise DependencyUnknownError, "#{name} has not been declared as a dependency" unless self.class.dependencies.include?(name)
      @injections.set(name, dependency)
      self
    end

    # Injects dependencies
    #
    # @params [Hash] injections
    #
    # @return [self]
    #
    # @example
    #   register_user.injects(user_repo: double, user_mailer: double)
    #
    # @api public
    def injects(injections)
      injections.each { |name, dependency| inject(name, dependency) }
    end

    # Returns injections
    #
    # @example
    #   register_user.injections
    #
    # @return [Injections]
    #
    # @api private
    def injections
      @injections.dup.freeze
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

      # Declare a dependency
      #
      # @param [Symbol] name
      # @param [Hash] options
      #
      # @example
      #   class MyThing
      #     depdendency :user_repo, default: -> { User }
      #   end
      #
      # @api public
      def dependency(name, options = {})
        dependencies.add(name, options)

        define_method name do
          @injections.get(name) do
            self.class.dependencies.fetch(name).default do
              raise NoInjectionError, "Dependency not injected and default not declared for #{name}"
            end
          end
        end

        private name

        self
      end

      def inherited(subclass)
        subclass.instance_variable_set("@dependencies", @dependencies)
        super
      end
    end

    private_constant :ClassMethods
  end
end
