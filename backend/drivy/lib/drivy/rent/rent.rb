module Drivy
  module Rent
    def self.load_rents_by_id_cars(cars, rents_list)
      rents = []
      rents_list.map do |rent_dict|
        selected_car = cars.select { |car| rent_dict['car_id'] == car.id }.first
        selected_car.rents = [] if selected_car.rents.nil?
        new_rent = Rent.new(rent_dict, selected_car)
        selected_car.rents << new_rent
        rents << new_rent
      end
      rents
    end

    class Rent < RentCalcul
      RENTAL_MODIFICATIONS = 'rental_modifications'.freeze

      attr_accessor :rental_modifications

      def initialize(rent_dict, car)
        super
      end

      def to_hash
        new_hach = super
        unless rental_modifications.nil?
          new_hach[RENTAL_MODIFICATIONS] = rental_modifications.map(&:to_hash)
        end
        new_hach
      end
    end
  end
end
