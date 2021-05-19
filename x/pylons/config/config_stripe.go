package config

import ( 
	"os"
	"strings" 
)

type StripeConfig struct {
	StripePublishableKey string   `json:"stripePublishableKey"`
	StripeCountry        string   `json:"stripeCountry"`
	Country              string   `json:"country"`
	Currency             string   `json:"currency"`
	PaymentMethods       []string `json:"paymentMethods"`
 
}


func PaymentMethods() []string {
	paymentMethodsString := os.Getenv("PAYMENT_METHODS")
	if paymentMethodsString == "" {
		return []string{"card"}
	} else {
		return strings.Split(paymentMethodsString, ", ")
	}
}

func Default() StripeConfig {
	stripeCountry := os.Getenv("STRIPE_ACCOUNT_COUNTRY")
	if stripeCountry == "" {
		stripeCountry = "US"
	}

	return StripeConfig{
		StripePublishableKey: os.Getenv("STRIPE_PUBLISHABLE_KEY"),
		StripeCountry:        stripeCountry,
		Country:              "US",
		Currency:             "usd",
		PaymentMethods:       PaymentMethods(), 
	}
}




 