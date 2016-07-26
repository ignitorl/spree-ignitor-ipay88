class CreateSpreeIpay88Transactions < ActiveRecord::Migration
  def change
    create_table :spree_ipay88_transactions do |t|
      t.integer :order_id 
      t.integer :payment_method_id 
      t.string  :transaction_number # unique transaction number within the scope of an order
      t.string  :ref_no # This will correspond to order.number. It is different from Order#id
      t.decimal :amount, :precision => 8, :scale => 2
      t.string  :currency
      t.string  :ipay88_amount # For the purpose of cross verifying when needed
      t.string  :state # Used by State machine gem to maintain various transaction states
      t.integer :status # Either 0= Failure or 1= Success
      t.string  :signature # Correspongs to response signature 
      t.string  :ipay88_payment_id 
      t.string  :error_description
      t.string  :auth_code # Authorization code from bank as fetched by ipay88
      t.text    :remark 
      t.string  :trans_id # Provided by ipay88

      t.timestamps
    end

    add_index :spree_ipay88_transactions, :order_id 
    add_index :spree_ipay88_transactions, :trans_id 
    add_index :spree_ipay88_transactions, :ref_no 
    add_index :spree_ipay88_transactions, :ipay88_payment_id
  end
end
