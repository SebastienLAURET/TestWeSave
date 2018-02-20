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
        new_hach = {}
        new_hach['deductible_reduction'] = @deductible_reduction
        new_hach
      end

      def to_json(*_)
        to_hash.to_json
      end

      private

      def calculate_deductible_reduction(nb_day, make_reduction)
        return REDU_PRICE_PER_DAY * nb_day.to_i if make_reduction
        0
      end

      def calculate_deductible_reduction!(nb_day, make_reduction)
        @deductible_reduction = calculate_deductible_reduction nb_day, make_reduction
      end
    end
  end
end
