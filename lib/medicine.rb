require "medicine/version"

require "medicine/core"
require "medicine/initializer"
require "medicine/setters"

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


  module DI
    private

    def self.included(base)
      base.class_eval do
        include Core
        include Initializer
        include Setters
      end
    end

    def self.prepend(base)
      base.class_eval do
        prepend Core
        prepend Initializer
        prepend Setters
      end
    end
  end
end
