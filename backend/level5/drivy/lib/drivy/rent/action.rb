module Drivy
  module Rent
    class Action
      # WHO VALUE
      DRIVER = 'driver'.freeze
      OWNER = 'owner'.freeze
      INSURANCE = 'insurance'.freeze
      ASSISTANCE = 'assistance'.freeze
      DRIVY = 'drivy'.freeze
      # TYPE VALUE
      DEBIT = 'debit'.freeze
      CREDIT = 'credit'.freeze

      def self.generate_driver_action(rent)
        amount = rent.calculate_price_with_reduction
        Action.new Action::DRIVER, Action::DEBIT, amount
      end

      def self.generate_owner_action(rent)
        amount = rent.calculate_price_without_commission
        Action.new Action::OWNER, Action::CREDIT, amount
      end

      def self.generate_insurance_action(rent)
        amount = rent.calculate_commission.insurance_fee
        Action.new Action::INSURANCE, Action::CREDIT, amount
      end

      def self.generate_assistance_action(rent)
        amount = rent.calculate_commission.assistance_fee
        Action.new Action::ASSISTANCE, Action::CREDIT, amount
      end

      def self.generate_drivy_action(rent)
        amount = rent.calculate_commission.drivy_fee + rent.calculate_options.deductible_reduction
        Action.new Action::DRIVY, Action::CREDIT, amount
      end

      attr_accessor :who, :type, :amount

      def initialize(who, type, amount)
        @who = who
        @type = type
        @amount = amount
      end

      def to_hash
        {
          who: @who,
          type: @type,
          amount: @amount
        }
      end

      def to_json(*_)
        to_hash.to_json
      end
    end
  end
end
