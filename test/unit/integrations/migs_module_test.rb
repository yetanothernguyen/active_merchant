require 'test_helper'

class MigsModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_service_url
    url = 'https://migs.mastercard.com.au/vpcpay'
    assert_equal url, Migs.service_url
  end
end 
