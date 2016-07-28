require 'sha1_encryptor'

module Spree
  module Ipay88Helper

    # Generates request parameters to be used in form which redirects the user to ipay88
    def request_params(payment_method,order)
      request_params = {"MerchantCode"=>payment_method.preferred_merchant_code,"RefNo"=>order.number,
        "Amount"=>get_amount(order),"Currency"=>order.currency,"ProdDesc"=>order.prod_desc,
        "UserName"=>"","UserEmail"=>"","UserContact"=>"",
        "Remark"=>"","Signature"=>get_request_signature(payment_method,order),"ResponseURL"=>""}
    end

    def get_amount(order)
      order.total.to_money.format(thousands_separator:',',symbol:false)
    end

    def get_simplified_amount(order)
      order.total.to_money.format(thousands_separator:false,symbol:false).gsub('.','')
    end

    # Calculates request signature which is used by Ipay88 to verify if the request is received with right amount from the right merchant 
    def get_request_signature(payment_method,order)
     params = {merchant_key:payment_method.preferred_merchant_key,merchant_code:payment_method.preferred_merchant_code,
      ref_no:order.number,simplified_amount:get_simplified_amount(order),currency:order.currency}
      SHA1Encryptor.request_signature(params)
    end

    # Directly send in response params to generate response signature
    def get_response_signature(params,merchant_key)
      simplified_amount = params["Amount"].gsub(/[\.\,]/,"")
      signature_params = {merchant_key:merchant_key,merchant_code:params["MerchantCode"],payment_id:params["PaymentId"],
      ref_no:params["RefNo"],simplified_amount:simplified_amount,currency:params["Currency"],
      status:params["Status"]}
      SHA1Encryptor.response_signature(signature_params)
    end
  end
end
