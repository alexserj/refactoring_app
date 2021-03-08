# lib/gigmit/concern/negotation.rb

module Gigmit
  module Concern
    module Negotiation
      extend ActiveSupport::Concern

      included do
        attr_accessible :user_id,
                        :artist_id,
                        :promoter_id,
                        :gig_id

                        # ...

        belongs_to :user
        belongs_to :artist
        belongs_to :promoter
        belongs_to :gig, counter_cache: true

        scope :unblocked, -> { joins(:user).where("users.blocked = ?", false ) }
        scope :blocked,   -> { joins(:user).where("users.blocked = ?", true  ) }

        validates :user,
                  :artist,
                  :promoter,
                  :gig_id,

                  # ...

                  presence: true

        # ...

        #I would propose to remove these two methods #artist and #promoter
        #since I have not found presence of default_scope
        def artist
          Artist.unscoped{ super }
        end

        def promoter
          Promoter.unscoped{ super }
        end

        # ...

      end
    end
  end
end
