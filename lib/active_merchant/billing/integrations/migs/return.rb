module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Migs
        class Return < ActiveMerchant::Billing::Integrations::Return
        	def success?
            acknowledge && params['vpc_TxnResponseCode'] == '0'
          end 

          def item_id
            params['vpc_MerchTxnRef']
          end

          def transaction_no
            params['vpc_TransactionNo']
          end

          def authorize_id
            params['vpc_AuthorizeId']
          end

          def receipt_no
            params['vpc_ReceiptNo']
          end

          def payer_card
            params['vpc_Card']
          end
         
          def message
            params['vpc_Message']
          end

          def response_code
            params['TxnResponseCode']
          end

          def acknowledge
            signature == params['vpc_SecureHash']
          end

          def signature
            unescape_params = params.map
            Helper::sign(@options[:credential2], params)
          end
	      end
      end
    end
  end
end
