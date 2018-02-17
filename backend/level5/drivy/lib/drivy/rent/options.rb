module Drivy
  module Rent
    class Options
      # OPERATION VALUE
      REDU_PRICE_PER_DAY = 400

      attr_accessor :deductible_reduction

      def initialize(nb_days, make_reduction)
        calculate_deductible_reduction! nb_days, make_reduction
      end

      def to_hash
        {
          deductible_reduction: @deductible_reduction
        }
      end

      def to_json(*_)
        JSON.generate to_hash
      end

      private

      def calculate_deductible_reduction(nb_day, make_reduction)
        return REDU_PRICE_PER_DAY * nb_day if make_reduction
        0
      end

      def calculate_deductible_reduction!(nb_day, make_reduction)
        @deductible_reduction = calculate_deductible_reduction nb_day, make_reduction
      end
    end
  end
end
