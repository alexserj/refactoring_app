# app/models/inquiry.rb

class Inquiry < ActiveRecord::Base
  include Gigmit::Concern::Negotiation
  include Gigmit::Concern::Riders

  # ...

end
