module Drivy
  module Rent
    def self.load_rents_by_id_cars cars, rents_list
      rents_list.map do |rent_dict|
        car = cars.select { |car| rent_dict['car_id'] == car.id }.first
        car.rents = Rent.new rent_dict, car
      end
    end

    class Rent

      SECOND_IN_DAY = (60*60*24)

      attr_accessor :id, :car_id, :start_date, :end_date, :distance, :deductible_reduction, :commission, :car

      def initialize rent_dict, car
        @id = rent_dict['id']
        @car_id = rent_dict['car_id']
        @start_date = Time.parse rent_dict['start_date']
        @end_date = Time.parse rent_dict['end_date']
        @distance = rent_dict['distance']
        @deductible_reduction = rent_dict['deductible_reduction']
        @car = car
        @commissions = Commission.new calculate_price, calculate_nb_days
      end

      def calculate_options
        reduc = 0
        reduc = 400 * calculate_nb_days if @deductible_reduction
      end

      def calculate_nb_days
        nb_second = @end_date - @start_date
        nb_days = (nb_second / SECOND_IN_DAY) + 1
        nb_days.round
      end

      def calculate_price
        calculate_price_per_km + calculate_price_per_day
      end

      def to_hash
        {
          id: @id,
          car_id: @car_id,
          start_date: @start_date,
          end_date: @end_date,
          distance: @distance,
          deductible_reduction: @deductible_reduction,
          commissions: @commissions
        }
      end

      def to_json *arg
        JSON.generate to_hash
      end

      private

      def calculate_price_per_km
        (@distance * @car.price_per_km)
      end

      def calculate_price_per_day
        (calculate_nb_days * @car.price_per_day) - calculate_discount
      end

      def calculate_discount
        nb_days = calculate_nb_days
        discount = 0

        if nb_days > 10
          discount += (nb_days - 10) * (@car.price_per_day * (50.0/100.0))
          nb_days = 10
        end
        if nb_days > 4
          discount += (nb_days - 4) * (@car.price_per_day * (30.0/100.0))
          nb_days = 4
        end
        if nb_days > 1
          discount += (nb_days - 1) * (@car.price_per_day * (10.0/100.0))
        end
        discount
      end

    end
  end
end
