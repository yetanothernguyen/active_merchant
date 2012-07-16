require 'test_helper'

class PayDollarNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @pay_dollar = PayDollar::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @pay_dollar.complete?
    assert_equal "", @pay_dollar.status
    assert_equal "", @pay_dollar.transaction_id
    assert_equal "", @pay_dollar.item_id
    assert_equal "", @pay_dollar.gross
    assert_equal "", @pay_dollar.currency
    assert_equal "", @pay_dollar.received_at
    assert @pay_dollar.test?
  end

  def test_compositions
    assert_equal Money.new(3166, 'USD'), @pay_dollar.amount
  end

  # Replace with real successful acknowledgement code
  def test_acknowledgement    

  end

  def test_send_acknowledgement
  end

  def test_respond_to_acknowledge
    assert @pay_dollar.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    ""
  end  
end
