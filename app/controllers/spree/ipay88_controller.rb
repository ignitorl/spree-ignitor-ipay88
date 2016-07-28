module Spree
  class Ipay88Controller < StoreController
    # Because call back should come from Ipay. They don't have an authenticity token
    skip_before_action :verify_authenticity_token, only: :callback
    # Ensure that the callback is redirected from Ipay88' secure server
    before_action :check_signature, only: :callback
    helper 'spree/orders'
    include Spree::Ipay88Helper

    # This is the method which renders the form which redirects to Ipay88 upon form submission from user's browser
    def show
      # We initially let the user to pick which payment method he wants to use. Payment method id therefore comes from the user
      @payment_method = Spree::PaymentMethod.find(params[:payment_method_id])

      if !@payment_method or !@payment_method.kind_of?(Spree::Ipay88::PaymentMethod)
        # if by any chance
        flash[:error] = 'Invalid payment method'
        # Don't render anything just show a flash message in the existing screen (checkout#edit)
        render :error
        return
      end      

      @order = current_order
      if @order.has_authorized_ipay88_transaction?
        # if by any chance, we get to the url by copy pasting the link etc., we flash useful error message
        flash[:error] = 'Order #{@order.number} is already authorized at Ipay88'
        # Don't render anything just show a flash message in the existing screen (checkout#edit)
        render :error
        return
      end

      # Precautions
      @order.cancel_existing_ipay88_transactions!
      @order.payments.destroy_all

      # Creates new payment and a corresponding Ipay88 transaction
      @order.payments.build(amount:@order.total,payment_method_id:@payment_method.id)
      @transaction = @order.ipay88_transactions.build( amount:@order.total, currency:@order.currency.to_s, payment_method_id:@payment_method.id )
      @transaction.transact # shifts the transaction state from 'created' to 'sent'. We didn't really send the transaction to ipay88 yet. 
      #   Now all we have left is to make the user submit the form

      # We save the order, the corresponding payment and ipay88 transaction in the database
      @order.save!
      # these are needed on the view
      @bill_address, @ship_address = @order.bill_address, (@order.ship_address || @order.bill_address)
      logger.info("Will send order #{@order.number} to Ipay88 with local transaction ID: #{@transaction.id}")
    end    

    # Responds to the Ipay88 initiated redirect. This is the URL which is given to Ipay88 as a redirect/callback url

    def callback
      @transaction.status = params["Status"]
      @transaction.ipay88_payment_id  = params["PaymentId"].to_s
      @transaction.ref_no = params["RefNo"] # Spree's order.number 
      @transaction.ipay88_amount = params["Amount"] # Stored seperately, in case
      @transaction.remark = params["Remark"]
      @transaction.trans_id = params["TransId"].to_s
      @transaction.auth_code = params["AuthCode"]
      @transaction.error_description = params["ErrDesc"] 
      @transaction.signature = params["Signature"]

      session[:access_token] = @transaction.order.guest_token if @transaction.order.respond_to?(:guest_token)
      session[:order_id] = @transaction.order.id

      if @transaction.next
        # Handles transaction states
        if @transaction.authorized? # Success
          session[:order_id] = nil
          flash[:success] = I18n.t(:success)
          # Google analytics part
          # flash[:commerce_tracking] = 'nothing special'
          if session[:access_token].nil?
            redirect_to order_path(@transaction.order, {:order_complete => true})
          else  # Enables the url to be reused and copied else where a.k.a the page will still be displayed
            redirect_to order_path(@transaction.order, {:order_complete => true, :token => session[:access_token]})
          end
        else # Failure
          redirect_to edit_order_path(@transaction.order), :error => @transaction.error_description
        end
      else
        render 'error'
      end
    end

    private

    def check_signature
      @transaction = Spree::Ipay88::Transaction.find(params[:id])
      raise "Transaction with id: #{params[:id]} not found!" unless @transaction
      merchant_key = @transaction.payment_method.preferred_merchant_key
      # Produces white screen
      @ipay88_error = params["ErrDesc"]
      render 'error' unless params["Signature"] == get_response_signature(params,merchant_key)
    end

  end
end