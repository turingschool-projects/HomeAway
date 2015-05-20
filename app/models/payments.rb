class Payments
  def self.process_payment(cart, user, stripeToken)
    customer = Stripe::Customer.create(
      email: user.email_address,
      card: stripeToken
    )

    Stripe::Charge.create(
      customer: customer.id,
      amount: cart.total_cents,
      description: 'HomeAway Reservation',
      currency: 'usd'
    )
  end
end
