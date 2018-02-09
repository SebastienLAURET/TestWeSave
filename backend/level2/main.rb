require "json"
require 'date'
require 'time'

def read_file file_name
  data = ""
  file = File.new(file_name, "r")
  while (line = file.gets)
    data << line
  end
  file.close
  return data
end

def write_result_in_file file_name, str
  data = ""
  File.new(file_name, 'w')
  File.open(file_name, "w"){ |file|
    file.write(str)
    file.close
  }
  return data
end

def join_data cars_list, rents_list
    cars_list.each do |car|
      car['rentals'] = []
      rents_list.each do |rental|
        if (car['id'] === rental['car_id'])
          car['rentals'] << rental
        end
      end
    end
    return cars_list
end

def calculate_price_by_cars cars_list
  result = Hash.new
  result['rentals'] = Array.new

  cars_list.each do |car|
    nb_days = 0
    nb_km = 0

    car['rentals'].each do |rent|
      puts rent
      nb_days += Time.parse(rent['end_date']) - Time.parse(rent['start_date'])
      nb_days = (nb_days / (60*60*24)) + 1
      nb_days = nb_days.round

      price_by_day = nb_days.to_i * car['price_per_day'].to_i

      nb_km += rent['distance']
      price_by_km = nb_km.to_i * car['price_per_km'].to_i


      price = price_by_km + price_by_day
      puts price
      if nb_days > 1
        price -= price * (10.0/100.0)
      elsif nb_days > 4
        price -= price * (30.0/100.0)
      elsif nb_days > 10
        price -= price * (50.0/100.0)
      end
      puts price

      tmp_rent = {
          :id =>  rent['id'],
          :price => price.round
      }
      result['rentals'].push tmp_rent
    end
  end
  return result
end


dict_data = JSON.parse read_file "data.json"
puts dict_data.inspect
cars_list = join_data dict_data['cars'], dict_data['rentals']
puts cars_list.inspect
result = calculate_price_by_cars cars_list
puts result

write_result_in_file "out.json", JSON.generate(result)
