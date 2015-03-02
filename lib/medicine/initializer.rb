module Medicine
  module Initializer
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
      super()
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
        super(name, options)

        define_method name do
          @injections.fetch(name) do
            self.class.dependencies.fetch(name).default do
              raise NoInjectionError, "Dependency not injected and default not declared for #{name}"
            end
          end
        end

        private name

        self
      end
    end

    private_constant :ClassMethods
  end
end
