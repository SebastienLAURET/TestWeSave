module Drivy
  module Rent
    class Commission
      MARGES = (30.0 / 100.0)
      ASSISTANCE_PRICE_PER_DAY = 100

      attr_accessor :commission_total, :insurance_fee
      attr_accessor :assistance_fee, :drivy_fee

      def initialize(price, nb_days)
        calculate_Commission! price
        calculate_insurance_fee!
        calculate_assistance_fee! nb_days
        calculate_drivy_fee!
      end

      def to_hash
        {
          insurance_fee: @insurance_fee,
          assistance_fee: @assistance_fee,
          drivy_fee: @drivy_fee
        }
      end

      def to_json(*_)
        JSON.generate to_hash
      end

      private

      def calculate_commission(price)
        price * MARGES
      end

      def calculate_commission!(price)
        @commission_total = calculate_Commission price
      end

      def calculate_insurance_fee
        @commission_total / 2.0
      end

      def calculate_insurance_fee!
        @insurance_fee = calculate_insurance_fee
      end

      def calculate_assistance_fee(nb_days)
        ASSISTANCE_PRICE_PER_DAY * nb_days
      end

      def calculate_assistance_fee!(nb_days)
        @assistance_fee = calculate_assistance_fee nb_days
      end

      def calculate_drivy_fee
        @commission_total - (@insurance_fee + @assistance_fee)
      end

      def calculate_drivy_fee!
        @drivy_fee = calculate_drivy_fee
      end
    end
  end
end
