module ReviewsHelper
  def rating_select_list
    5.downto(1).map {|num| [pluralize(num, "star"), num]}
  end
end
