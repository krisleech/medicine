module Medicine
  module Setters
    def self.included(base)
      base.class_eval do
        public :inject
        public :injects
      end
    end
  end
end
