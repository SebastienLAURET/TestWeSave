module Drivy
  module Rent
    def self.load_rents_by_id_cars(cars, rents_list)
      rents_list.map do |rent_dict|
        selected_car = cars.select { |car| rent_dict['car_id'] == car.id }.first
        selected_car.rents ||= []
        selected_car.rents << Rent.new(rent_dict, selected_car)
      end
    end

    class Rent
      # HASH KEY
      ID = 'id'.freeze
      CAR_ID = 'car_id'.freeze
      START_DATE = 'start_date'.freeze
      END_DATE = 'end_date'.freeze
      DISTANCE = 'distance'.freeze
      DEDUCTIBLE_REDUCTION = 'deductible_reduction'.freeze
      # OPERATION VALUE
      SECOND_IN_DAY = (60 * 60 * 24)
      DISCOUNT_ARR = [
        { begin: 1, end: 4, discount: (10.0 / 100.0) },
        { begin: 4, end: 10, discount: (30.0 / 100.0) },
        { begin: 10,  discount: (50.0 / 100.0) }
      ].freeze

      attr_accessor :id, :car_id, :start_date, :end_date
      attr_accessor :distance, :deductible_reduction, :car

      def initialize(rent_dict, car)
        @id = rent_dict[ID]
        @car_id = rent_dict[CAR_ID]
        @start_date = Time.parse rent_dict[START_DATE]
        @end_date = Time.parse rent_dict[END_DATE]
        @distance = rent_dict[DISTANCE]
        @deductible_reduction = rent_dict[DEDUCTIBLE_REDUCTION]
        @car = car
      end

      def calculate_options
        Options.new calculate_nb_days, @deductible_reduction
      end

      def calculate_commission
        Commission.new calculate_price, calculate_nb_days
      end

      def calculate_nb_days
        nb_second = @end_date - @start_date
        nb_days = (nb_second / SECOND_IN_DAY) + 1
        nb_days.round
      end

      def calculate_price
        calculate_price_per_km + calculate_price_per_day
      end

      def calculate_price_with_reduction
        calculate_price + calculate_options.deductible_reduction
      end

      def calculate_price_without_commission
        calculate_price - calculate_commission.commission_total
      end

      def generate_actions_list
        actions_list = []
        actions_list << Action.generate_driver_action(self)
        actions_list << Action.generate_owner_action(self)
        actions_list << Action.generate_insurance_action(self)
        actions_list << Action.generate_assistance_action(self)
        actions_list << Action.generate_drivy_action(self)
      end

      def to_hash
        new_hach = {}
        new_hach[ID] = @id
        new_hach[CAR_ID] = @car_id
        new_hach[START_DATE] = @start_date
        new_hach[END_DATE] = @end_date
        new_hach[DISTANCE] = @distance
        new_hach[DEDUCTIBLE_REDUCTION] = @deductible_reduction,
        new_hach['price'] = calculate_price
        new_hach['commissions'] = calculate_commission.to_hash
        new_hach['options'] = calculate_options.to_hash
        new_hach['actions'] = generate_actions_list.map(&:to_hash)
        new_hach
      end

      def to_json(*_)
        to_hash.to_json
      end

      private

      def calculate_price_per_km
        (@distance * @car.price_per_km)
      end

      def calculate_price_per_day
        (calculate_nb_days * @car.price_per_day) - calculate_discount
      end

      def calculate_discount
        price_discount = 0

        DISCOUNT_ARR.each do |disc_dict|
          begin_r = disc_dict[:begin]
          end_r = disc_dict[:end]
          disc = disc_dict[:discount]
          price_discount += calculate_discount_per_day begin_r, end_r, disc
        end
        price_discount
      end

      def calculate_discount_per_day(begin_range, end_range, discount)
        discount_per_day = 0
        nb_days = calculate_nb_days

        if nb_days > begin_range
          end_range = nb_days if end_range.nil? || nb_days < end_range
          range = (end_range - begin_range)
          discount_per_day += range * (@car.price_per_day * discount)
        end
        discount_per_day.round
      end
    end
  end
end
