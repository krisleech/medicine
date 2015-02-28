require "medicine/version"
require "medicine/dependencies"
require "medicine/define_methods"

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
    def initialize(*args)
      @injections = Injections.new
      set_injections_for_args(args)
      DefineMethods.on(self)
      super
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

    def set_injections_for_args(args)
      (args.last.respond_to?(:[]) ? args.pop : {}).each do |name, dependency|
        inject(name, dependency)
      end
    end

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
