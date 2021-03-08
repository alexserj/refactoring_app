# app/models/gig.rb

class Gig < ActiveRecord::Base

  # ...

  belongs_to :user
  belongs_to :promoter, counter_cache: true

  has_many :inquiries,   dependent: :destroy
  has_many :gig_invites, dependent: :destroy

  serialize :custom_fields, Array

  # ...

end
