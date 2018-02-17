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
        type = def_driver_type amount
        Action.new DRIVER, type, amount.abs
      end

      def self.generate_owner_action(rent)
        amount = rent.calculate_price_without_commission
        type = def_default_type amount
        Action.new Action::OWNER, type, amount.abs
      end

      def self.generate_insurance_action(rent)
        amount = rent.calculate_commission.insurance_fee
        type = def_default_type amount
        Action.new Action::INSURANCE, type, amount.abs
      end

      def self.generate_assistance_action(rent)
        amount = rent.calculate_commission.assistance_fee
        type = def_default_type amount
        Action.new Action::ASSISTANCE, type, amount.abs
      end

      def self.generate_drivy_action(rent)
        amount = rent.calculate_commission.drivy_fee + rent.calculate_options.deductible_reduction
        type = def_default_type amount
        Action.new Action::DRIVY, type, amount.abs
      end

      def self.def_default_type amount
        if amount > 0
          return CREDIT
        else
          return DEBIT
        end
      end

      def self.def_driver_type amount
        def_default_type (-amount)
      end

      attr_accessor :who, :type, :amount

      def initialize(who, type, amount)
        @who = who
        @type = type
        @amount = amount
      end

      def to_hash
        new_hach = {}
        new_hach['who'] = @who
        new_hach['type'] = @type
        new_hach['amount'] = @amount
        new_hach
      end

      def to_json(*_)
        to_hash.to_json
      end
    end
  end
end
