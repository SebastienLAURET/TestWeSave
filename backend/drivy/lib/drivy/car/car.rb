module Drivy
  module Car
    def self.load_data(filename)
      file = File.read filename
      data_dict = JSON.parse file
      cars = data_dict['cars'].map { |car| Car.new car }
      rents = Rent.load_rents_by_id_cars cars, data_dict['rentals']
      Rent.load_rents_modif_by_id_rent rents, data_dict['rental_modifications']
      cars
    end

    class Car
      # HASH KEY
      ID = 'id'.freeze
      PRICE_PER_DAY = 'price_per_day'.freeze
      PRICE_PER_KM = 'price_per_km'.freeze

      attr_accessor :id, :price_per_day, :price_per_km, :rents

      def initialize(car_dict)
        @id = car_dict[ID]
        @price_per_day = car_dict[PRICE_PER_DAY]
        @price_per_km = car_dict[PRICE_PER_KM]
      end

      def calculate_options
        @rents.map(&:calculate_options)
      end

      def calculate_commissions
        @rents.map(&:calculate_commission)
      end

      def generate_actions_list
        @rents.map(&:generate_actions_list)
      end

      def to_hash
        {
          id: @id,
          price_per_day: @price_per_day,
          price_per_km: @price_per_km,
          rents: @rents
        }
      end

      def to_json(*_)
        to_hash.to_json
      end
    end
  end
end
