# app/models/artist.rb

class Artist < Profile

  # ...

  serialize :contact_person

  has_many :inquiries, dependent: :destroy
  has_many :gig_invites, dependent: :destroy

  # ...

  has_one :billing_address, as: :addressable, class_name: 'Address',
          conditions: {used_for: 'billing'}

  has_one :catering_rider, as: :attachable, class_name: 'MediaItem',
          conditions: { item_type: 'catering_rider'  }

  has_one :technical_rider, as: :attachable, class_name: 'MediaItem',
          conditions: { item_type: 'technical_rider' }

  # ...

  def billing_address_attributes=(attrs)
    if attrs[:name].blank? || attrs[:street].blank? || attrs[:street_number].blank? ||
       attrs[:city].blank? || attrs[:country].blank?

      self.billing_address.destroy if self.billing_address.present?
    else
      #self.billing_address = Address.new(attrs)
      assign_nested_attributes_for_one_to_one_association(:billing_address, attrs)
    end
  end

  # ...

  #returns the last value of 'field' of all created inquiries
  #example:
  #  Artist.last.last_inquired(:artist_salary_for_this_inquiry)
  #  returns the salary of the last inquiry from that Artist
  #  if there aren't any inquiries it returns nil
  def last_inquired(field)
    last = nil
    self.inquiries.reverse.each do |inquiry|
      last = inquiry.send(field)
      break if last
    end
    last
  end

  # ...

end
