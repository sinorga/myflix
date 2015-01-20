module UsersHelper
  def show_follow_btn(user)
    if current_user.can_follow?(user)
      link_to "Follow", followees_path(followee_id: user.id), class: "btn btn-default", method: :post
    end
  end
end
