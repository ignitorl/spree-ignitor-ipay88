module Spree
  CheckoutController.class_eval do 

    before_action :push_to_ipay88_show_action, only: :update

    private 

    # This is the hook which pushes/redirects user to ipay88 show page for the first time
    def push_to_ipay88_show_action
      # Perform this redirect only if the order is in payment state
      return unless (params[:state] == 'payment') && params[:order][:payments_attributes]
      # The user already has picked Ipay88. 
      # So we will have the corresponding payment method for Ipay88 in the parameter
      payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      if payment_method && payment_method.kind_of?(Spree::Ipay88::PaymentMethod)
        redirect_to gateway_ipay88_path(@order.number, payment_method.id)
      end
    end

  end
end