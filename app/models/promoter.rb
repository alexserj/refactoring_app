# app/models/promoter.rb

class Promoter < Profile

  # ...

  has_many :gigs,             dependent: :destroy
  has_many :inquiries,        dependent: :destroy

  # ...

end
