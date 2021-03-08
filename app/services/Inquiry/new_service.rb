class Inquiry::NewService
  attr_accessor :profile, :is_matching

  def perform
    setup_inquiry
  end

  private

  def setup_inquiry
    head_params
    fees
    riders
    is_matching
    billing_address
    services
  end

  def head_params
    @inquiry.gig                   = @gig
    @inquiry.deal_possible_fee_min = @gig.deal_possible_fee_min
    @inquiry.artist_contact        = @current_profile.last_inquired(:artist_contact)
    @inquiry.travel_party_count    = @current_profile.last_inquired(:travel_party_count)
    @inquiry.custom_fields         = @gig.custom_fields
  end

  def fees
    if @gig.fixed_fee_option && @gig.fixed_fee_max == 0
      @inquiry.fixed_fee = 0
    end

    if @gig.fixed_fee_negotiable
      @inquiry.gig.fixed_fee_option = true
      @inquiry.gig.fixed_fee_max    = 0
    end
  end

  def riders
    # set this rider here for new
    # if user keeps it until create, they will be copied async
    # otherwise he can pseudo delete the riders in the Inquiry#new form and
    # add new ones
    @inquiry.technical_rider = @current_profile.technical_rider
    @inquiry.catering_rider  = @current_profile.catering_rider
  end

  def billing_address
    if @current_profile.billing_address.blank? || @current_profile.tax_rate.blank?
      profile_billing_address
    end
  end

  def profile_billing_address
    @profile = @current_profile
    if @profile.billing_address.blank?
      @profile.build_billing_address
      @profile.billing_address.name = billing_address_name
    end
  end

  def billing_address_name
    [
      @profile.main_user.first_name,
      @profile.main_user.last_name
    ].join(' ')
  end

  def is_matching
    # Gigmit::Matcher#matches? returns a boolean whether an aritst matches a
    # given gig
    @is_matching = Gigmit::Matcher.new(@gig, @current_profile).matches?
  end

  def services
    Gigmit::Intercom::Event::ApplicationSawIncompleteBillingDataWarning.emit(@gig.id, @current_profile.id) unless current_profile.has_a_complete_billing_address?
    Gigmit::Intercom::Event::ApplicationSawIncompleteEpkWarning.emit(@gig.id, @current_profile.id) unless current_profile.epk_complete?

    Gigmit::Intercom::Event::ApplicationVisitedGigApplicationForm.emit(@gig.id, @current_profile.id) if current_profile.complete_for_inquiry?
  end
end
