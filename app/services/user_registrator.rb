class UserRegistrator
  attr_reader :user, :inviter, :invitation, :message

  def initialize(user)
    @user = user
  end

  def register(stripe_token, invite_token)
    begin
      register!(stripe_token, invite_token)
      @status = :success
    rescue StripeWrapper::CardError => e
      @status = :card_error
      @message = e.message
    rescue ActiveRecord::RecordInvalid
      @status = :record_error
    end
    self
  end

  def success?
    @status == :success
  end

  def card_error?
    @status == :card_error
  end

  private
  def register!(stripe_token, invite_token)
    set_invitation_datas(invite_token)
    User.transaction do
      user.save!
      stripe_payment!(stripe_token)
      welcome
      relationship_with_inviter
    end
  end

  def stripe_payment!(stripe_token)
    customer = StripeWrapper::Customer.create(
      source: stripe_token,
      user: user
    )
    user.update!(stripe_id: customer.customer_id)
  end

  def welcome
    UserMailer.delay.welcome(user)
  end

  def relationship_with_inviter
    if inviter
      user.follow(inviter)
      inviter.follow(user)
      invitation.expire
    end
  end

  def set_invitation_datas(invite_token)
    if invite_token.present?
      @invitation = Invitation.find_by(token: invite_token)
      @inviter = @invitation.try(:inviter)
    end
  end
end
