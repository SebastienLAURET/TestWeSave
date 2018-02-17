module Drivy
  def self.start
    car_list = Car.load_data '../data/data.json'

    rentals_dict = {}
    rents_list = []
    car_list.map do |car|
      car.rents.each { |rent| rents_list << rent.to_hash }
    end
    rentals_dict['rentals'] = rents_list

    file = File.read '../data/output.json'
    output_dict = JSON.parse file

    compare_dict output_dict, rentals_dict
  end

  def self.compare_dict(expected, dict)
    expected.each do |key, value|

      if value.class == dict[key].class
        if value.class == Hash
          compare_dict value, dict[key]
        elsif value.class == Array
          compare_array value, dict[key]
        else
          puts "ERROR :: [#{key}] value expected #{value} value read #{dict[key]}" if value != dict[key]
        end
      else
        puts "ERROR :: [#{key}] class expected #{value.class} class read #{dict[key].class}"
      end
    end
  end
  def self.compare_array(expected, array)
    expected.each do |value|
      selected_elem = array.select do |elem|
        flag = false
        if !value['id'].nil?
          flag = (elem['id'] == value['id'])
        else
          flag = (elem['who'] == value['who'])
        end
        flag
      end
      selected_elem = selected_elem.first unless selected_elem.empty?
      if value.class == selected_elem.class
        if value.class == Hash
          compare_dict value, selected_elem
        elsif value.class == Array
          compare_array value, selected_elem
        else
          puts "ERROR :: value expected #{value} value read #{selected_elem}" if value != selected_elem
        end
      else
        puts "ERROR :: value expected #{value} value read #{selected_elem}"
      end
    end
  end


end
