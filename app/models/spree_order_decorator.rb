Spree::Order.class_eval do 
  has_many :ipay88_transactions, :class_name => "Spree::Ipay88::Transaction"

  def has_authorized_ipay88_transaction?
    ipay88_transactions.select{|txn| txn.authorized?}.present?
  end

  def cancel_existing_ipay88_transactions!
    ipay88_transactions.each{|t| t.cancel!}
  end

  def prod_desc
    self.products.map(&:name).join(",")
  end

end