module Drivy
  def self.start
    car_list = Car.load_data '../data/data.json'
    puts car_list.to_json
  end
end
