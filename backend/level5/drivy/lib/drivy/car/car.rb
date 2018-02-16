module Drivy
  module Car
    def self.load_data filename
      file = File.read(filename)
      data_dict = JSON.parse(file)
      cars = data_dict['cars'].map { |car|  Car.new car, data_dict['cars'] }
      Rent::load_rents_by_id_cars cars, data_dict['rentals']
      cars
    end

    class Car

      attr_accessor :id, :price_per_day, :price_per_km, :rents

      def initialize car_dict, rents_list = nil
        @id = car_dict["id"]
        @price_per_day = car_dict["price_per_day"]
        @price_per_km = car_dict["price_per_km"]
      end

      def to_hash
        {
          id: @id,
          price_per_day: @price_per_day,
          price_per_km: @price_per_km,
          rents: @rents
        }
      end

      def to_json *arg
        JSON.generate to_hash
      end
    end
  end
end
