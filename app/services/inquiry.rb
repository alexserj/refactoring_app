module Inquiry
  def initialize(inquiry:, gig:, current_profile:, current_user: nil, params: nil)
    @inquiry = inquiry
    @gig = gig
    @current_user = current_user
    @current_profile = current_profile
    @params = params
  end
end
