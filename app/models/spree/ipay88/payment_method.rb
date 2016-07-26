module Spree
  class Ipay88::PaymentMethod < Spree::PaymentMethod
    preference :merchant_code, :string
    preference :merchant_key, :string

    # This is the url to which we redirect user to pay money through ipay88 gateway
    def url
      "https://www.mobile88.com/epayment/entry.asp"
    end

    # Auto capture of payments. Leave it true always. 
    def auto_capture?
      true
    end

    # For the sake of Spree you need to add a purchase class with success? and authorization methods, 
    # mention the transaction provider class, payment source class and a method type named 
    def purchase(amount, source, options = {})
      Class.new do
        def success?;
          true;
        end

        def authorization;
          nil;
        end
      end.new
    end

    def provider_class
      Spree::Ipay88::Transaction
    end

    def payment_source_class
      Spree::Ipay88::Transaction
    end

    def method_type
      'ipay88'
    end

  end
end