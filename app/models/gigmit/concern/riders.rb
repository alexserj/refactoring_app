# lib/gigmit/concern/riders.rb

module Gigmit
  module Concern
    module Riders
      extend ActiveSupport::Concern

      included do
        has_one :technical_rider, class_name: 'MediaItem', as: :attachable, conditions: { item_type: 'technical_rider' }
        has_one :catering_rider,  class_name: 'MediaItem', as: :attachable, conditions: { item_type: 'catering_rider'  }

        # ...

      end
    end
  end
end
