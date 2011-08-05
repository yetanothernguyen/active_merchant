require 'test_helper'

class MigsReturnTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
  	@ret = Migs::Return.new(success_http_raw_query, :credential2 => 'F83309329A07BFCFA1F289F41FCD5F85')
  end

  def test_accessors
    assert @ret.acknowledge
  	assert @ret.success?
  	assert_equal "Approved", @ret.message
  	assert_equal "2000000124", @ret.transaction_no
  	assert_equal "DEF", @ret.item_id
  	assert_equal "484706", @ret.authorize_id
  end

  def test_fail_response
    fail_ret = Migs::Return.new(fail_http_raw_query, :credential2 => 'F83309329A07BFCFA1F289F41FCD5F85')

    assert fail_ret.acknowledge
    assert !fail_ret.success?    
  end

  def success_http_raw_query
  	"email=cody%40example.com&vpc_3DSXID=kTPjSZx2OIsA6OMfB2Iexvcvv%2Bc%3D&vpc_3DSenrolled=N&vpc_AVSRequestCode=Z&vpc_AVSResultCode=Unsupported&vpc_AcqAVSRespCode=Unsupported&vpc_AcqCSCRespCode=Unsupported&vpc_AcqResponseCode=00&vpc_Amount=50000&vpc_AuthorizeId=484706&vpc_BatchNo=20110416&vpc_CSCResultCode=Unsupported&vpc_Card=VC&vpc_Command=pay&vpc_Locale=en&vpc_MerchTxnRef=DEF&vpc_Merchant=TESTHBM60025800&vpc_Message=Approved&vpc_OrderInfo=order-500&vpc_ReceiptNo=110614484706&vpc_SecureHash=A190EF37FD254E0EC72A41C59BC1FF10&vpc_TransactionNo=2000000124&vpc_TxnResponseCode=0&vpc_VerSecurityLevel=06&vpc_VerStatus=E&vpc_VerType=3DS&vpc_Version=1"
  end

  def fail_http_raw_query
    "email=cody%40example.com&vpc_3DSECI=05&vpc_3DSXID=V5m21obzYz3al75s4V6yNSXrC8E%3D&vpc_3DSenrolled=Y&vpc_3DSstatus=Y&vpc_AVSRequestCode=Z&vpc_AVSResultCode=Unsupported&vpc_AcqAVSRespCode=Unsupported&vpc_AcqCSCRespCode=Unsupported&vpc_AcqResponseCode=14&vpc_Amount=50000&vpc_BatchNo=20110417&vpc_CSCResultCode=Unsupported&vpc_Card=VC&vpc_Command=pay&vpc_Locale=en&vpc_MerchTxnRef=DEF&vpc_Merchant=TESTHBM60025800&vpc_Message=Declined&vpc_OrderInfo=order-500&vpc_ReceiptNo=110703487375&vpc_SecureHash=D77FB0D45E00880BB2C1A30526ABBC65&vpc_TransactionNo=2000000125&vpc_TxnResponseCode=2&vpc_VerSecurityLevel=05&vpc_VerStatus=Y&vpc_VerToken=AAABCBlJVydAAAAVUklXAAAAAAA%3D&vpc_VerType=3DS&vpc_Version=1"
  end
end