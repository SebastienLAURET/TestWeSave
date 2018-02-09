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

def calculate_nb_days start_date, end_date
  nb_days = 0
  nb_days += Time.parse(end_date) - Time.parse(start_date)
  nb_days = (nb_days / (60*60*24)) + 1
  nb_days = nb_days.round
  return nb_days
end

def calculate_price_by_day car, rent
  nb_days = calculate_nb_days rent['start_date'], rent['end_date']
  offre = adjust_price_by_day car['price_per_day'].to_i, nb_days
  price_by_day = (nb_days.to_i * car['price_per_day'].to_i) - offre
  return price_by_day
end


def calculate_price_by_km car, rent
  nb_km = 0
  nb_km += rent['distance']
  price_by_km = nb_km.to_i * car['price_per_km'].to_i
  return price_by_km
end

def adjust_price_by_day price, nb_days
  result = 0
  if nb_days > 10
    result += (nb_days - 10) * (price * (50.0/100.0))
    nb_days = 10
  end
  if nb_days > 4
    result += (nb_days - 4) * (price * (30.0/100.0))
    nb_days = 4
  end
  if nb_days > 1
    result += (nb_days - 1) * (price * (10.0/100.0))
  end
  return result
end

def calculate_commission price, rent
  commission_total = price * (30.0/100.0)
  insurance_fee = commission_total / 2.0
  assistance_fee = 100 * calculate_nb_days(rent['start_date'], rent['end_date'])
  drivy_fee = commission_total - (insurance_fee + assistance_fee)
  result = {
    :insurance_fee => insurance_fee.round,
    :assistance_fee => assistance_fee,
    :drivy_fee => drivy_fee.round
  }
  return result
end

def calculate_options rent
  reduc = 400 * ((rent['deductible_reduction'] == true) ? calculate_nb_days(rent['start_date'], rent['end_date']) : 0)
  result = {
    :deductible_reduction => reduc
  }
  return result
end

def calculate_price_by_cars cars_list
  result = Hash.new
  result['rentals'] = Array.new

  cars_list.each do |car|
    nb_days = 0
    nb_km = 0

    car['rentals'].each do |rent|
      price_by_day = calculate_price_by_day car, rent
      price_by_km = calculate_price_by_km car, rent
      price = price_by_km + price_by_day
      commission = calculate_commission price, rent
      options = calculate_options rent
      tmp_rent = {
          :id =>  rent['id'],
          :price => price.round,
          :options => options,
          :commissions => commission
      }
      result['rentals'].push tmp_rent
    end
  end
  return result
end


dict_data = JSON.parse read_file "data.json"
cars_list = join_data dict_data['cars'], dict_data['rentals']
result = calculate_price_by_cars cars_list
write_result_in_file "out.json", JSON.generate(result)
