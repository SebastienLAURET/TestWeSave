module Drivy
  module Rent
    class Commission
      # OPERATION VALUE
      MARGES = (30.0 / 100.0)
      ASSISTANCE_PRICE_PER_DAY = 100

      attr_accessor :commission_total, :insurance_fee
      attr_accessor :assistance_fee, :drivy_fee

      def initialize(price, nb_days)
        calculate_commission! price
        calculate_insurance_fee!
        calculate_assistance_fee! nb_days
        calculate_drivy_fee!
      end

      def to_hash
        new_hach = {}
        new_hach['insurance_fee'] = @insurance_fee
        new_hach['assistance_fee'] = @assistance_fee
        new_hach['drivy_fee'] = @drivy_fee
        new_hach
      end

      def to_json(*_)
        to_hash.to_json
      end

      private

      def calculate_commission(price)
        (price * MARGES).round
      end

      def calculate_commission!(price)
        @commission_total = calculate_commission price
      end

      def calculate_insurance_fee
        (@commission_total / 2.0).round
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
