module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PayDollar
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          mapping :merchant,      'merchantId'
          mapping :account,       'name'
          mapping :email,         'email'
          mapping :amount,        'amount'
          mapping :order,         'orderRef'
          mapping :mps,           'mpsMode'
          mapping :currency_code, 'currCode'
          mapping :language,      'lang'
          mapping :cancel_url,    'cancelUrl'
          mapping :fail_url,      'failUrl'
          mapping :success_url,   'successUrl'
          mapping :pay_type,      'payType'
          mapping :pay_method,    'payMethod'
          mapping :app_id,        'appId'
          mapping :schedule_type, 'schType'
          mapping :number_schedule, 'nSch'
          mapping :start_month,     'sMonth'
          mapping :start_day,       'sDay'
          mapping :start_year,     'sYear'
          mapping :end_month,       'eMonth'
          mapping :end_day,         'eDay'
          mapping :end_year,       'eYear'
          mapping :schedule_status, 'schStatus'

          def initialize(order, account, options = {})
            super

            add_field mappings[:merchant], options[:credential2]
          end

          def form_fields
            @fields
          end
        end
      end
    end
  end
end
