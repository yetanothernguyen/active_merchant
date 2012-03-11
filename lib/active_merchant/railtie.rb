module ActiveMerchant
  class Railtie < Rails::Railtie
    initializer 'activemerchant.initialize' do
      ActiveSupport.on_load(:action_view) do
        include ActiveMerchant::Billing::Integrations::ActionViewHelper
      end
    end
  end
end