require 'test_helper'

class MigsHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
    @helper = Migs::Helper.new('order-500','cody@example.com', 
                                :amount => 500,
                                :credential2 => 'F83309329A07BFCFA1F289F41FCD5F85',
                                :credential3 => 'TESTHBM60025800',
                                :credential4 => 'B2D3DC4F')
  end
 
  def test_basic_helper_fields
    assert_field 'email', 'cody@example.com'
    assert_field 'vpc_Amount', '50000'
    assert_field 'vpc_OrderInfo', 'order-500'
    assert_field 'vpc_Merchant', 'TESTHBM60025800'
    assert_field 'vpc_AccessCode', 'B2D3DC4F'
    assert_field 'vpc_Command', Migs::Helper::COMMAND
    assert_field 'vpc_Version', Migs::Helper::VERSION
    assert_field 'vpc_Locale', Migs::Helper::LOCALE
  end

  def test_other_helper_fields
    @helper.reference_id = 'DEF'
    assert_field 'vpc_MerchTxnRef', 'DEF'

    @helper.return_url = 'http://example.org/return'
    assert_field 'vpc_ReturnURL', 'http://example.org/return'
  end

  def test_secure_hash
    @helper.reference_id = 'DEF'
    @helper.return_url = 'http://example.org/return'

    assert_equal '4168DEDF283A075DBB323310FB427B11', @helper.signature

    # assert_equal Digest::MD5.hexdigest(['SECRET','cody@example.com','Code A','50000',Migs::Helper::COMMAND,Migs::Helper::LOCALE,'DEF','Merchant A','order-500','here',Migs::Helper::VERSION].join('')), @helper.signature
  end
 
end
