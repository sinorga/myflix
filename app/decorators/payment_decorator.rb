class PaymentDecorator < Draper::Decorator
  delegate_all

  def show_amount
    "$#{amount_with_dollar}"
  end

  private
  def amount_with_dollar
    (amount/100.0).round(2)
  end

end
