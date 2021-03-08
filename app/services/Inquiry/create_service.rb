class Inquiry::CreateService
  def perform
    create_inquiry
    @inquiry
  end

  private

  def create_inquiry
    head_params
    validate_inquiry
    save_inquiry
  end

  def head_params
    @inquiry.gig        = @gig
    @inquiry.artist     = @current_profile
    @inquiry.user       = @current_profile.main_user
    @inquiry.promoter   = @gig.promoter
  end

  def existing_gig_invite
    @existing_gig_invite ||= current_profile.gig_invites.find_by(gig_id: params[:gig_id])
  end

  def emit_existing_gig_invite
    Event::Read.emit(:gig_invite, @existing_gig_invite)
  end

  def validate_inquiry
    #if inquiry is valid, which means we will definitivly after this, copy
    #the riders from the current profile to the inquiry
    populate_inquiry if @inquiry.valid?
  end

  def save_inquiry
    if @inquiry.save
      populate_profile

      run_services

      emit_existing_gig_invite if @existing_gig_invite.present?
    end
  end

  def populate_inquiry
    if @current_profile.technical_rider.present? && @current_profile.technical_rider.item_hash == @params[:inquiry][:technical_rider_hash]
      add_technical_rider_to_inquiry
    end

    if @current_profile.catering_rider.present? && @current_profile.catering_rider.item_hash == @params[:inquiry][:catering_rider_hash]
      add_catering_rider_to_inquiry
    end
  end

  def add_technical_rider_to_inquiry
    @inquiry.build_technical_rider(user_id: @current_user.id).save!
    MediaItemWorker.perform_async(@current_profile.technical_rider.id, @inquiry.technical_rider.id)
  end

  def add_caterign_rider_to_inquirycatering_rider
    @inquiry.build_catering_rider(user_id: @current_user.id).save!
    MediaItemWorker.perform_async(@current_profile.catering_rider.id, @inquiry.catering_rider.id)
  end

  def populate_profile
    #if profile has no rides yet, which means, this is the profiles first inquiry ever
    #copy the riders from the inquiry to the profile
    if current_profile.technical_rider.blank? && @inquiry.technical_rider.present?
      add_technical_rider_to_profile
    end

    if current_profile.catering_rider.blank? && @inquiry.catering_rider.present?
      add_caterign_rider_to_profile
    end
  end

  def add_technical_rider_to_profile
    current_profile.build_technical_rider(user_id: current_user.id).save!
    MediaItemWorker.perform_async(@inquiry.technical_rider.id, current_profile.technical_rider.id)
  end

  def add_caterign_rider_to_profile
    current_profile.build_catering_rider(user_id: current_user.id).save!
    MediaItemWorker.perform_async(@inquiry.catering_rider.id, current_profile.catering_rider.id)
  end

  def run_services
    Event::WatchlistArtistInquiry.emit(@inquiry.id)

    Gigmit::Intercom::Event::Simple.emit('gig-received-application', @gig.promoter_id)
    IntercomCreateOrUpdateUserWorker.perform_async(@gig.promoter_id)
  end
end
