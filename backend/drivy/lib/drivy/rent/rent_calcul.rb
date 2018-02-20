module Drivy
  module Rent
    class RentCalcul < RentBasic
      # HASH KEY
      PRICE = 'price'.freeze
      COMMISSION = 'commission'.freeze
      ACTIONS = 'actions'.freeze
      OPTIONS = 'options'.freeze
      # OPERATION VALUE
      SECOND_IN_DAY = (60 * 60 * 24)
      DISCOUNT_ARR = [
        { begin: 1, end: 4, discount: (10.0 / 100.0) },
        { begin: 4, end: 10, discount: (30.0 / 100.0) },
        { begin: 10,  discount: (50.0 / 100.0) }
      ].freeze

      attr_accessor :car

      def initialize(rent_dict, car)
        super rent_dict
        @car = car
      end

      def calculate_options
        Options.new calculate_nb_days, deductible_reduction
      end

      def calculate_commission
        Commission.new calculate_price, calculate_nb_days
      end

      def calculate_nb_days
        nb_second = end_date - start_date
        nb_days = (nb_second.to_i / SECOND_IN_DAY) + 1
        nb_days.round
      end

      def calculate_price
        calculate_price_per_km + calculate_price_per_day
      end

      def calculate_price_with_reduction
        calculate_price + calculate_options.deductible_reduction.to_i
      end

      def calculate_price_without_commission
        calculate_price - calculate_commission.commission_total.to_i
      end

      def generate_actions_list
        actions_list = []
        actions_list << Action.generate_driver_action(self)
        actions_list << Action.generate_owner_action(self)
        actions_list << Action.generate_insurance_action(self)
        actions_list << Action.generate_assistance_action(self)
        actions_list << Action.generate_drivy_action(self)
        actions_list
      end

      def to_hash
        new_hach = super
        new_hach[PRICE] = calculate_price
        new_hach[COMMISSION] = calculate_commission.to_hash
        new_hach[OPTIONS] = calculate_options.to_hash
        new_hach[ACTIONS] = generate_actions_list.map(&:to_hash)
        new_hach
      end

      def to_json(*_)
        to_hash.to_json
      end

      private

      def calculate_price_per_km
        (distance.to_i * car.price_per_km.to_i)
      end

      def calculate_price_per_day
        (calculate_nb_days * car.price_per_day.to_i) - calculate_discount
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
          if end_range.nil? || nb_days.to_i < end_range.to_i
            end_range = nb_days.to_i
          end
          range = (end_range.to_i - begin_range.to_i)
          discount_per_day += range.to_i * (car.price_per_day.to_i * discount)
        end
        discount_per_day.round
      end
    end
  end
end
