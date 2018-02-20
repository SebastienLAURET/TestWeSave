module Drivy
  module Rent
    def self.load_rents_modif_by_id_rent(rents_list, modif_list)
      rents_modifs = []
      unless modif_list.nil?
        modif_list.map do |modif_dict|
          rents_modifs << create_rents_modif(rents_list, modif_dict)
        end
      end
      rents_modifs
    end

    def self.create_rents_modif(rents_list, modif_dict)
      selected_car = rents_list.select do |rent|
        modif_dict['rental_id'] == rent.id
      end.first
      selected_car.rental_modifications ||= []
      new_rental_modif = RentalModifications.new(modif_dict, selected_car)
      selected_car.rental_modifications << new_rental_modif
      new_rental_modif
    end

    class RentalModifications < RentCalcul
      # HASH KEY
      RENTAL_ID = 'rental_id'.freeze

      attr_accessor :rental_id, :rent

      def initialize(modif_dict, rent)
        @id = modif_dict[ID]
        @rental_id = modif_dict[RENTAL_ID]
        unless modif_dict[START_DATE].nil?
          @start_date = Time.parse(modif_dict[START_DATE])
        end
        unless modif_dict[END_DATE].nil?
          @end_date = Time.parse(modif_dict[END_DATE])
        end
        @distance = modif_dict[DISTANCE]
        @rent = rent
      end

      def calculate_options
        Options.new calculate_diff_nb_days, deductible_reduction
      end

      def calculate_commission
        Commission.new calculate_price, calculate_diff_nb_days
      end

      def calculate_price
        super.to_i - rent.calculate_price.to_i
      end

      def calculate_diff_nb_days
        calculate_nb_days - rent.calculate_nb_days
      end

      def start_date
        return @start_date unless @start_date.nil?
        @rent.start_date
      end

      def end_date
        return @end_date unless @end_date.nil?
        @rent.end_date
      end

      def distance
        return @distance unless @distance.nil?
        @rent.distance
      end

      def deductible_reduction
        @rent.deductible_reduction
      end

      def car
        @rent.car
      end

      def to_hash
        new_hach = super
        new_hach[RENTAL_ID] = @rental_id
        new_hach
      end
    end
  end
end
