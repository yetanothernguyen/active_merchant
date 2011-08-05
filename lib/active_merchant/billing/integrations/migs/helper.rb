module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Migs
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          # Replace with the real mapping
          mapping :account,       'email'
          mapping :access_code,   'vpc_AccessCode'
          mapping :amount,        'vpc_Amount'
          mapping :command,       'vpc_Command'
          mapping :locale,        'vpc_Locale'
          mapping :reference_id,  'vpc_MerchTxnRef'
          mapping :merchant,      'vpc_Merchant'
          mapping :order,         'vpc_OrderInfo'
          mapping :return_url,    'vpc_ReturnURL'
          mapping :version,       'vpc_Version'
          mapping :secure_hash,   'vpc_SecureHash'

          VERSION = '1'
          COMMAND = 'pay'
          LOCALE  = 'en'

          def initialize(order, account, options = {})
            super

            add_field mappings[:version], VERSION
            add_field mappings[:command], COMMAND
            add_field mappings[:locale], LOCALE

            @secret_code = options[:credential2]
            add_field mappings[:merchant], options[:credential3]
            add_field mappings[:access_code], options[:credential4]
          end

          # Convert to cents
          def amount=(money)
            amount = money.to_f
            if amount <= 0
              raise ArgumentError, 'amount must be positive'
            end

            amount = (amount * 100).to_i
            add_field mappings[:amount], amount
          end

          def form_fields
            @fields.merge(mappings[:secure_hash] => signature)
          end

          def signature
            self.class.sign(@secret_code, @fields)
          end

          def self.sign(prefix, params)
            hash_input = prefix
            params.reject { |k,v| k == mappings[:secure_hash] }.sort.each { |p| hash_input += p.last }
            
            return Digest::MD5.hexdigest(hash_input).upcase
          end
        end
      end
    end
  end
end
