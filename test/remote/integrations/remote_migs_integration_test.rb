require 'test_helper'
require 'remote/integrations/remote_integration_helper'
require 'nokogiri'

class RemoteValitorIntegrationTest < Test::Unit::TestCase
  include RemoteIntegrationHelper

   def setup
    @order = "order-500"
    @email = "cody@example.com"

    @secret_code = "F83309329A07BFCFA1F289F41FCD5F85"
    @merchant = "TESTHBM60025800"
    @access_code = "B2D3DC4F"
  end

  def test_full_purchase

  end

  def test_form_fields
    str = %(
      <% payment_service_for('#{@order}', '#{@email}', :service => :migs, :amount => 500, :credential2 => '#{@secret_code}', :credential3 => '#{@merchant}', :credential4 => '#{@access_code}', :html => {:method => 'GET'}) do |service| %>
        <% service.reference_id  'DEF' %>
        <% service.return_url 'http://localhost/return' %>

      <% end %>
    )

    view = FakeView.new
    body = view.render(:inline => str)
    page = Mechanize::Page.new(nil, {'content-type' => 'text/html; charset=utf-8'}, body, nil, agent)

    form = page.forms.first
    assert_equal '9A630BA1EDF7A92CB0809559328E91B9', form['vpc_SecureHash']
  end
end
