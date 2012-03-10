require 'test_helper'

class Ipay88Test < Test::Unit::TestCase
  def setup
    @gateway = Ipay88Gateway.new(
                 :login => 'M03242',
                 :password => 'rvxfqQV58t'
               )

    @credit_card = credit_card
    @amount = 100
    
    @options = { 
      :reference_no => '2',
      :first_payment_date => "11112011",
      :amount => @amount,
      :number_of_payments => 10,
      :frequency => 1,
      :description => "Test subscription",
      :cc_country => "Malaysia",
      :cc_bank => "Maybank",
      :cc_ic => "123456789",
      :cc_email => "customer@email.com",
      :cc_phone => "123456789",
      :cc_remark => "Test subscription",
      :name => "John Chin",
      :email => "customer@email.com",
      :phone => "123456789",
      :address_line1 => "Address Line 1",
      :address_line2 => "Address Line 2",
      :city => "Petaling Jaya",
      :state => "Selangor",
      :zipcode => "47301",
      :country => "Malaysia"
    }
  end
  
  def test_successful_recurring
    #@gateway.expects(:ssl_post).returns(successful_recurring_response)
    
    response = @gateway.recurring(@amount, @credit_card, @options)
    assert_instance_of Response, response
    assert_success response
    
    # Replace with authorization number from the successful response
    assert_equal 'S00001384', response.authorization
    #assert response.test?
  end

  def test_unsuccessful_recurring
    #@gateway.expects(:ssl_post).returns(failed_recurring_response)
    
    assert response = @gateway.recurring(@amount, @credit_card, @options)
    assert_failure response
    assert_equal 'Duplicate Refno', response.message
    #assert response.test?
  end

  private
  
  # Place raw successful response from gateway here
  def successful_recurring_response
    <<-XML
    <SubscriptionDetails xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.mobile88.com">
      <MerchantCode>M03242</MerchantCode>
      <Refno>1</Refno>
      <SubscriptionNo>S00001384</SubscriptionNo>
      <FirstPaymentDate>11112011</FirstPaymentDate>
      <Currency>MYR</Currency>
      <Amount>100</Amount>
      <NumberOfPayments>10</NumberOfPayments>
      <Frequency>Monthly</Frequency>
      <Desc>Test subscription</Desc>
      <Status>1</Status>
      <Errdesc />
    </SubscriptionDetails>
    XML
  end
  
  # Place raw failed response from gateway here
  def failed_recurring_response
    <<-XML
    <SubscriptionDetails xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.mobile88.com">
      <MerchantCode>M03242</MerchantCode>
      <Refno>1</Refno>
      <SubscriptionNo />
      <FirstPaymentDate>11112011</FirstPaymentDate>
      <Currency>MYR</Currency>
      <Amount>1.00</Amount>
      <NumberOfPayments>10</NumberOfPayments>
      <Frequency>Monthly</Frequency>
      <Desc>Test subscription</Desc>
      <Status>0</Status>
      <Errdesc>Duplicate Refno</Errdesc>
    </SubscriptionDetails>
    XML
  end
end
