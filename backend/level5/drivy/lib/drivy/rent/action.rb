module Drivy
  module Rent
    class Action
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
