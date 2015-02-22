jQuery(function($) {
  $('#new_user').submit(function(event) {
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find(":submit").prop('disabled', true);

    Stripe.card.createToken({
      number: $('.card-number').val(),
      cvc: $('.card-cvc').val(),
      exp_month: $('.card-expiry-month').val(),
      exp_year: $('.card-expiry-year').val()
    }, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });

  var stripeResponseHandler = function(status, response) {
    var $form = $('#new_user');

    if (response.error) {
      // Show the errors on the form
      $form.find('.payment-errors').text(response.error.message).css({
        color: "#A94442"
      });
      $form.find(':submit').prop('disabled', false);
    } else {
      $form.find('.payment-errors').text('');
      // response contains id and card, which contains additional card details
      var token = response.id;
      // Insert the token into the form so it gets submitted to the server
      $form.append($('<input type="hidden" name="stripeToken" />').val(
        token));
      // and submit
      $form.get(0).submit();
    }
  };
});
