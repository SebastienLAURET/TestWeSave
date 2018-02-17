module Drivy
  def self.start
    car_list = Car.load_data '../data/data.json'
    puts JSON.pretty_generate JSON.parse(car_list.to_json)
  end
end
