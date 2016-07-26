require 'test_helper'

class SHA1EncryptorTest < Minitest::Test
  def test_should_produce_correct_signature 
    assert_equal '84dNMbfgjLMS42IqSTPqQ99cUGA=',SHA1Encryptor.digest("appleM00003A00000001100MYR")
  end

  def test_the_truth
    assert true
  end
end
