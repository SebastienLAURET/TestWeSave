module Drivy
  module Car
    def self.load_data(filename)
      file = File.read filename
      data_dict = JSON.parse file
      cars = data_dict['cars'].map { |car| Car.new car }
      Rent.load_rents_by_id_cars cars, data_dict['rentals']
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

      def to_hash
        {
          id: @id,
          price_per_day: @price_per_day,
          price_per_km: @price_per_km,
          rents: @rents
        }
      end

      def to_json(*_)
        JSON.generate to_hash
      end
    end
  end
end
