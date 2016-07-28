require 'digest/sha1'
class SHA1Encryptor

  # Creates signature based on the information needed as per ipay88
  def self.request_signature(params)
    # Ref No. is same as order number
    # amount should be stripped of commas and periods. And it should be only till 2 decimal digits
    cipher = params[:merchant_key]+params[:merchant_code]+
    params[:ref_no]+params[:simplified_amount]+params[:currency]
    self.digest(cipher)
  end

# The intended purpose of this method is to verify the signature received from ipay88 for additional security
  def self.response_signature(params)
    # payment id is the one received from ipay88. It is different from spree's payment id
    # status  is basically 1 or 0 1= success, 0 = failure. This too, is received from ipay88
    cipher = params[:merchant_key]+params[:merchant_code]+
    params[:payment_id]+params[:ref_no]+params[:simplified_amount]+params[:currency]+params[:status]
    self.digest(cipher)
  end



  def self.digest(target_string)
    digest = Digest::SHA1.digest(target_string)
    #  encodes it in base64
    [digest].pack("m").chomp
  end
end