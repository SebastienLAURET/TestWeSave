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
        JSON.generate to_hash
      end
    end
  end
end
