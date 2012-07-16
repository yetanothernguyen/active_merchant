require File.dirname(__FILE__) + '/pay_dollar/helper.rb'
require File.dirname(__FILE__) + '/pay_dollar/return.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PayDollar 
       
        mattr_accessor :production_url
        mattr_accessor :test_url
        self.production_url = 'https://live.sagepay.com/gateway/service/vspform-register.vsp'
        self.test_url       = 'https://test.paydollar.com/b2cDemo/eng/payment/payForm.jsp'

        def self.return(query_string, options = {})
          Return.new(query_string, options)
        end

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
          when :production
            self.production_url    
          when :test
            self.test_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end
      end
    end
  end
end
