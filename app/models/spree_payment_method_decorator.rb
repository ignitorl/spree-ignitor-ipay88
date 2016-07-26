Spree::PaymentMethod.class_eval do
  has_many :ipay88_transactions, :class_name => "Spree::Ipay88::Transaction"
end