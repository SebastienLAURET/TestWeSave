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
      puts "====#{key}===="
      compare_elem value, dict[key]
    end
  end

  def self.compare_array(expected, array)
    if array.size == expected.size
      array.sort! { |elemA, elemB| sort_dict elemA, elemB }
      expected.sort! { |elemA, elemB| sort_dict elemA, elemB }
      array.size.times { |index| compare_elem(expected[index], array[index]) }
    end
  end

  def self.compare_elem(value, elem)
    if value.class == elem.class
      if value.class == Hash
        compare_dict value, elem
      elsif value.class == Array
        compare_array value, elem
      else
        if value != elem
          puts "ERROR :: value expected #{value} value read #{elem}"
        else
          puts "DONE :: value expected #{value} value read #{elem}"
        end
      end
    else
      puts "ERROR :: value expected #{value} value read #{elem}"
    end
  end

  def self.sort_dict(elemA, elemB)
    if !elemA['id'].nil?
      value = (elemA['id'] <=> elemB['id'])
    else
      value = (elemA['who'] <=> elemB['who'])
    end
    value
  end

end
