require 'test_helper'

class PayDollarModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_notification_method
    assert_instance_of PayDollar::Notification, PayDollar.notification('name=cody')
  end
end 
