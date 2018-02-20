module Drivy
  module Rent
    class RentBasic
      # HASH KEY
      ID = 'id'.freeze
      CAR_ID = 'car_id'.freeze
      START_DATE = 'start_date'.freeze
      END_DATE = 'end_date'.freeze
      DISTANCE = 'distance'.freeze
      DEDUCTIBLE_REDUCTION = 'deductible_reduction'.freeze

      attr_accessor :id, :car_id, :start_date, :end_date
      attr_accessor :distance, :deductible_reduction

      def initialize(rent_dict)
        @id = rent_dict[ID]
        @car_id = rent_dict[CAR_ID]
        @start_date = Time.parse rent_dict[START_DATE]
        @end_date = Time.parse rent_dict[END_DATE]
        @distance = rent_dict[DISTANCE]
        @deductible_reduction = rent_dict[DEDUCTIBLE_REDUCTION]
      end

      def to_hash
        new_hach = {}
        new_hach[ID] = @id
        new_hach[CAR_ID] = car_id
        new_hach[START_DATE] = start_date
        new_hach[END_DATE] = end_date
        new_hach[DISTANCE] = distance
        new_hach[DEDUCTIBLE_REDUCTION] = deductible_reduction
        new_hach
      end
    end
  end
end
