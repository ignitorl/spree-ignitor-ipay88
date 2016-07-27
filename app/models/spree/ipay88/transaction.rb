module Spree
  # Ipay88 transaction class. The model which handles transaction records on the store when done through Ipay88
  class Ipay88::Transaction < ActiveRecord::Base
    belongs_to :order, class_name:"Spree::Order"
    belongs_to :payment_method, class_name:"Spree::Ipay88::PaymentMethod"
    has_many :payments, :as => :source 

    def actions 
      ["capture","void"]
    end

    # Only captures payments that have checkout and pending states
    def can_capture?(payment)
     ['checkout', 'pending'].include?(payment.state)
    end

    def can_void?(payment)
      payment.state != 'void'
    end
 
    #  The following methods first update the state from checkout to 
    #  pending as required by the state machine used by payments class
    # After the transaction, capture payment

    def capture(payment)
      payment.update_attribute(:state,'pending') if payment.state == 'checkout'
      payment.complete
      true
    end

    # Method to void payments in case there are issues with transaction
    def void(payment)
      payment.update_attribute(:state,'pending') if payment.state =='checkout'
      payment.complete 
      true
    end

    # Uses state machine provided automatically when you require spree/core
    #TODO update states according to the statuses received after writing controller 

    state_machine :initial=> :created, :use_transactions => false do 

      before_transition :to => :sent, :do => :initialize_state!

      event :transact do 
        transition :created => :sent 
      end

      event :next do 
        transition [:sent, :batch] => :authorized, :if => lambda {|txn| txn.status == 1}
        transition [:sent, :batch] => :failed, :if => lambda {|txn| txn.status == 0}
     end

     after_transition :to => :authorized, :do => :payment_authorized
     
     # This is useful when internet failure occurs and
     # after the user retries the payment via a new transaction
     #  It is important to note that a new transaction gets created
     #   as soon as an old transaction is moved to cancelled state and a user retries the operation.
     #   Another way to create a cancelled transaction is 
     # when we query the Ipay88 server to know if the transaction is aborted for any reason.
     # In that case since the transaction is already in cancelled state,
     # it won't cause any inconsistency when a new transaction is initiated

     event :cancel do 
      transition all - [:authorized] => :cancelled
     end
    end

    def payment_authorized
      payment = order.payments.where(:payment_method_id=>self.payment_method.id).first
      payment.update_attributes :source => self, :payment_method_id => self.payment_method.id
      order.next
      order.save
    end

    def initialize_state!
      if order.confirmation_required? && !order.confirm?        
        raise "Order is not in 'confirm' state. Order should be in 'confirm' state before transaction can be sent to CCAvenue"
      end
      this = self
      previous = order.ipay88_transactions.reject {|t| t==this}
      previous.each {|p| p.cancel!}
      # This transaction number is unique only within the scope of order. 
      #This is to keep track of succesful and cancelled transactions.
      generate_transaction_number!
    end

    
    def gateway_order_number
      order.number + transaction_number
    end

    def generate_transaction_number!
      record = true
      #  attempts to create a record till you meet an unused transaction number and finaly creates a record 
      # whose transaction number is unique
      while record.present?
        random = "#{Array.new(4){rand(4)}.join}"
        record = Spree::Ipay88::Transaction.where(order_id: self.order.id,transaction_number: random)
      end
      self.transaction_number = random
    end

    def initialize(*args)
      if !args or args.empty?
        super(*args)
      else
        from_admin = args[0].delete('from_admin')
        super(*args)
        if from_admin
          self.amount = self.order.amount
          self.transact
          self.ipay88_amount = self.amount.to_s
          self.next
        end
      end
    end


  end

end