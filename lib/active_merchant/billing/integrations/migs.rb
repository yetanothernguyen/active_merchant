module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Migs 
      
        autoload :Return, 'active_merchant/billing/integrations/migs/return.rb'
        autoload :Helper, 'active_merchant/billing/integrations/migs/helper.rb'
       
        mattr_accessor :service_url
        self.service_url = 'https://migs.mastercard.com.au/vpcpay'

        def self.notification(post)
          Notification.new(post)
        end
         
        def self.return(post, options = {})
          Return.new(post, options)
        end
      end
    end
  end
end
