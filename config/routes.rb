Spree::Core::Engine.routes.draw do
  match '/gateway/:order_id/ipay88/:payment_method_id' => 'ipay88#show', :as => :gateway_ipay88, via: [:get, :post]
  # Here :id refers to ipay88 transaction ID. The response redirect is dynamically sent to this url
  match '/gateway/ipay88/:id/callback' => 'ipay88#callback', :as => :gateway_ipay88_callback, via: [:get, :post]
end
