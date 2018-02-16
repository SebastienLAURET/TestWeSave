module Drivy
  module Rent
    class Commission
      MARGES = (30.0/100.0)

      attr_accessor :insurance_fee, :assistance_fee, :drivy_fee

      def initialize price, nb_days
        commission_total = price * MARGES
        @insurance_fee = commission_total / 2.0
        @assistance_fee = 100 * nb_days
        @drivy_fee = commission_total - (insurance_fee + assistance_fee)
      end

      def to_hash
        {
          insurance_fee: @insurance_fee,
          assistance_fee: @assistance_fee,
          drivy_fee: @drivy_fee
        }
      end

      def to_json *args
        JSON.generate to_hash
      end

    end
  end
end
