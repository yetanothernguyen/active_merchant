module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class Ipay88Gateway < Gateway
      TEST_URL = ''
      LIVE_URL = 'https://www.ipay88.com/recurringpayment/webservice/RecurringPayment.asmx/Subscription'
      
      # The countries the gateway supports merchants from as 2 digit ISO country codes
      self.supported_countries = ['MY']
      
      # The card types supported by the payment gateway
      self.supported_cardtypes = [:visa, :master]
      
      # The homepage URL of the gateway
      self.homepage_url = 'https://www.ipay88.com/recurringpayment/webservice'
      
      # The name of the gateway
      self.display_name = 'iPay88'
      
      # Creates a new Ipay88Gateway
      #
      # The gateway requires that a valid login and password be passed
      # in the +options+ hash.
      #
      # ==== Options
      #
      # * <tt>:login</tt> -- The ipay88 Merchant Code (REQUIRED)
      # * <tt>:password</tt> -- The ipay88 Merchant Code (REQUIRED)
      def initialize(options = {})
        requires!(options, :login, :password)
        @options = options
        super
      end
      
      def recurring(money, creditcard, options = {})
        post = {}
        add_merchant_authentication(post, options)
        add_invoice(post, options)
        add_creditcard(post, creditcard, options)
        add_customer_data(post, options)
        add_address(post, options)
        add_signature(post, options)

        recurring_commit("subscribe", post)
      end
    
      private                    
      
      def add_merchant_authentication(post, options)
        post["MerchantCode"] = @options[:login]
        post["BackendURL"] = options[:backend_url]
      end
         
      def add_invoice(post, options)
        post["RefNo"] = options[:reference_no]
        post["FirstPaymentDate"] = options[:first_payment_date]
        post["Currency"] = "MYR"
        post["Amount"] = amount(options[:amount])
        post["NumberOfPayments"] = options[:number_of_payments]
        post["Frequency"] = options[:frequency]
        post["Desc"] = options[:description]
      end

      def add_creditcard(post, creditcard, options)
        post["CC_PAN"] = creditcard.number
        post["CC_CVC"] = creditcard.verification_value if creditcard.verification_value?
        post["CC_ExpiryDate"] = expdate(creditcard)
        post["CC_Name"] = creditcard.name
        post["CC_Country"] = options[:cc_country]
        post["CC_Bank"] = options[:cc_bank]
        post["CC_Ic"] = options[:cc_ic]
        post["CC_Email"] = options[:cc_email]
        post["CC_Phone"] = options[:cc_phone]
        post["CC_Remark"] = options[:cc_remark]
      end

      def add_customer_data(post, options)
        post["P_Name"] = options[:name]
        post["P_Email"] = options[:email]
        post["P_Phone"]= options[:phone]
      end

      def add_address(post, options)
        post["P_Addrl1"] = options[:address_line1]
        post["P_Addrl2"] = options[:address_line2]
        post["P_City"] = options[:city]
        post["P_State"] = options[:state]
        post["P_Zip"] = options[:zipcode]
        post["P_Country"] = options[:country]
      end

      def add_signature(post, options)
        hash_components  = [post["MerchantCode"]]
        hash_components << @options[:password]
        hash_components << post["RefNo"]
        hash_components << post["FirstPaymentDate"]
        hash_components << post["Currency"]
        hash_components << options[:amount] # Amount in cents
        hash_components << post["NumberOfPayments"]
        hash_components << post["Frequency"]
        hash_components << post["CC_PAN"]

        hash_string = hash_components.join

        post["Signature"] = [Digest::SHA1.digest(hash_string)].pack("m").chomp
      end

      def recurring_commit(action, parameters)
        request = post_data(action, parameters)
        xml = ssl_post LIVE_URL, request

        response = recurring_parse(xml)
        message = response[:errdesc]
        success = response[:status] == "1"

        Response.new(success, message, response,
            :authorization => response[:subscription_no]
        )
      end
      
      def recurring_parse(xml)
        response = {}
        xml = REXML::Document.new(xml)
        root = REXML::XPath.first(xml, "//SubscriptionDetails")
        if root
          root.elements.to_a.each do |node|
            recurring_parse_element(response, node)
          end
        end

        response
      end

      def recurring_parse_element(response, node)
        if node.has_elements?
          node.elements.each{|e| recurring_parse_element(response, e) }
        else
          response[node.name.underscore.to_sym] = node.text
        end
      end
      
      def post_data(action, parameters = {})
        post = {}

        request = post.merge(parameters).collect { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
        request
      end

      def expdate(creditcard)
        year  = sprintf("%.4i", creditcard.year)
        month = sprintf("%.2i", creditcard.month)

        "#{month}#{year}"
      end
    end
  end
end

