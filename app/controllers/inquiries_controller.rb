# app/controllers/gigs/inquiries_controller.rb

class Gigs::InquiriesController < Gigs::ApplicationController
  load_and_authorize_resource # https://github.com/CanCanCommunity/cancancan#32-loaders

  respond_to :html, only: [:new, :show]
  respond_to :json, only: [:create]

  before_filter :load_gig,       only: [:create, :new]

  def new
    service = Inquiry::NewService.new(
      inquiry: @inquiry,
      gig: @gig,
      current_profile: current_profile
    ).perform

    @is_matching = service.is_matching
    @profile = service.profile
  end

  def create
    inquiry = Inquiry::CreateService.new(
      inquiry: @inquiry,
      gig: @gig,
      current_profile: current_profile,
      current_user: current_user,
      params: params
    ).perform

    if inquiry.errors.any?
      render json: inquiry.errors, status: :unprocessable_entity
    else
      render json: inquiry, status: :created
    end
  end

  #only promoter use this
  def show
    #this redirect is for unfixed legacy links, because artist see inquiries
    #not prefixed with gig in the url
    redirect_to inquiry_path(@inquiry.id) and return if current_profile.artist?

    Event::Read.emit(:inquiry, @inquiry.id)
  end

  private

  def load_gig
    @gig = Gig.find_by(slug: params[:gig_id])
  end

  def paywall_chroot
    if current_profile.artist? && flash[:bypass_trial_chroot] != true
      # subscribe to premium-trial first to be able to use the platform at all
      redirect_to '/ab/gigmit-pro-free-trial' and return
    end
  end
end
