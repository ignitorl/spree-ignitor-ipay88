require 'test_helper'
class Ipay88HelperTest < Minitest::Test
  include Spree::Ipay88Helper
  def test_should_return_correct_response_signature
    params = {"MerchantCode"=>"M07082", "PaymentId"=>"2", "RefNo"=>"R919787733",
     "Amount"=>"1.00", "Currency"=>"MYR", "Remark"=>"", "TransId"=>"T109379261500", 
     "AuthCode"=>"352177", "Status"=>"1", "ErrDesc"=>"", "Signature"=>"ZwIIJgl/kTG3IygIC0ZIWD7NsnA=", 
     "TokenId"=>"", "BindCardErrDesc"=>"", "PANTrackNo"=>"", "id"=>"7"}
    merchant_key = "bXlp4zVIku"    
    assert_equal params["Signature"], get_response_signature(params,merchant_key)
  end
end