Rails.configuration.stripe = {
  publishable_key: "pk_test_6pRNASCoBOKtIshFeQd4XMUh",
  secret_key: "sk_test_BQokikJOvBiI2HlWgH4olfQ2"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
