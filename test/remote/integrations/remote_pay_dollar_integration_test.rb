require 'test_helper'
require 'remote/integrations/remote_integration_helper'
require 'nokogiri'

class RemoteValitorIntegrationTest < Test::Unit::TestCase
  include RemoteIntegrationHelper

   def setup
    @order = "order-500"
    @merchant = "uncf7463"
    ActiveMerchant::Billing::Base.integration_mode = :test
  end

  # def test_full_purchase
  #   notification_request = listen_for_notification(80) do |notify_url|
  #     payment_page = submit %(
  #       <% payment_service_for('#{@order}', '', :service => :pay_dollar, 
  #                                               :amount => 500, :credential2 => '#{@merchant}',
  #                                               :html => {:method => 'GET'}) do |service| %>
  #         <% service.mps = 'NIL' %>
  #         <% service.currency_code = '458' %>
  #         <% service.language = 'E' %>
  #         <% service.pay_type = 'N' %>
  #         <% service.pay_method = 'CC' %>
  #         <% service.cancel_url = 'http://localhost/cancel' %>
  #         <% service.fail_url = 'http://localhost/fail' %>
  #         <% service.success_url = 'http://localhost/success' %>
  #       <% end %>
  #     )

  #     puts payment_page.body
    
  #     # assert_match(%r(http://example.org/cancel)i, payment_page.body)
  #     # assert_match(%r(PRODUCT1), payment_page.body)
      
  #     # form = payment_page.forms.first
  #     # form['tbKortnumer'] = '4111111111111111'
  #     # form['drpGildistimiManudur'] = '12'
  #     # form['drpGildistimiAr'] = Time.now.year
  #     # form['tbOryggisnumer'] = '000'
  #     # result_page = form.submit(form.submits.first)
      
  #     # assert continue_link = result_page.links.detect{|e| e.text =~ /successtext!/i}
  #     # assert_match(%r(^http://example.org/return\?)i, continue_link.href)
      
  #     # check_common_fields(return_from(continue_link.href))
  #   end
    
  #   #check_common_fields(notification_from(notification_request))
  # end

  def test_form_fields
    str = %(
      <% payment_service_for('#{@order}', '', :service => :pay_dollar, 
                                              :amount => 500, :credential2 => '#{@merchant}',
                                              :html => {:method => 'GET'}) do |service| %>
        <% service.mps = 'NIL' %>
        <% service.currency_code = '458' %>
        <% service.language = 'E' %>
        <% service.pay_type = 'N' %>
        <% service.pay_method = 'CC' %>
        <% service.cancel_url = 'http://localhost/cancel' %>
        <% service.fail_url = 'http://localhost/fail' %>
        <% service.success_url = 'http://localhost/success' %>
      <% end %>
    )

    view = FakeView.new
    body = view.render(:inline => str)
    page = Mechanize::Page.new(nil, {'content-type' => 'text/html; charset=utf-8'}, body, nil, agent)

    form = page.forms.first
    #assert_equal '9A630BA1EDF7A92CB0809559328E91B9', form['vpc_SecureHash']
    puts body
  end
end
