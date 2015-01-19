module UsersHelper
  def show_follow_btn(user)
    unless current_user.followees.find_by_id(user.id)
      link_to "Follow", followees_path(followee_id: user.id), class: "btn btn-default pull-right", method: :post
    end
  end
end
