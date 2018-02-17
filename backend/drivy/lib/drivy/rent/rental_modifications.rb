module Drivy
  module Rent
    def self.load_rents_modif_by_id_rent(rents_list, rents_modif_list)
      rents_modifs = []
      unless rents_modif_list.nil?
        rents_modif_list.map do |rent_modif_dict|
          selected_car = rents_list.select { |rent| rent_modif_dict['rental_id'] == rent.id }.first
          selected_car.rental_modifications ||= []
          new_rental_modif = RentalModifications.new(rent_modif_dict, selected_car)
          selected_car.rental_modifications << new_rental_modif
          rents_modifs << new_rental_modif
        end
      end
      rents_modifs
    end

    class RentalModifications < Rent
      # HASH KEY
      RENTAL_ID = 'rental_id'.freeze

      attr_accessor :rental_id, :rent

      def initialize(rent_modif_dict, rent)
        @id = rent_modif_dict[ID]
        @rental_id = rent_modif_dict[RENTAL_ID]
        @start_date = Time.parse(rent_modif_dict[START_DATE]) unless rent_modif_dict[START_DATE].nil?
        @end_date = Time.parse(rent_modif_dict[END_DATE]) unless rent_modif_dict[END_DATE].nil?
        @distance = rent_modif_dict[DISTANCE]
        @rent = rent
      end

      def calculate_options
        Options.new calculate_diff_nb_days, deductible_reduction
      end

      def calculate_commission
        Commission.new calculate_price, calculate_diff_nb_days
      end

      def calculate_price
        super - rent.calculate_price
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
        new_hach = {}
        new_hach[ID] = @id
        new_hach[START_DATE] = @start_date  unless @start_date.nil?
        new_hach[END_DATE] = @end_date unless @end_date.nil?
        new_hach[DISTANCE] = @distance unless @distance.nil?
        new_hach[DEDUCTIBLE_REDUCTION] = @deductible_reduction unless @deductible_reduction.nil?
        new_hach[PRICE] = calculate_price
        new_hach[COMMISSION] = calculate_commission.to_hash
        new_hach[OPTIONS] = calculate_options.to_hash
        new_hach[ACTIONS] = generate_actions_list.map(&:to_hash)
        new_hach[RENTAL_ID] = @rental_id
        new_hach
      end
    end
  end
end
