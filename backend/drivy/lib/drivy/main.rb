module Drivy
  def self.start path
    car_list = Car.load_data "#{path}/data.json"

    #puts JSON.pretty_generate car_list.map(&:to_hash)

    rentals_dict = {}

    rents_list = car_list.select { |car| !car.rents.nil? }.map { |car| car.rents }.flatten
    rentals_dict['rentals'] = rents_list.map(&:to_hash)

    rents_modif_list = rents_list.select { |rent| !rent.rental_modifications.nil? }.map { |rent| rent.rental_modifications.map(&:to_hash) }.flatten
    rentals_dict['rental_modifications'] = rents_modif_list.map(&:to_hash) unless rents_modif_list.empty?

    file = File.read "#{path}/output.json"
    output_dict = JSON.parse file

    compare_dict output_dict, rentals_dict
  end

  def self.compare_dict(expected, dict)
    expected.each do |key, value|
      #      puts "====#{key}===="
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
        puts "ERROR :: value expected #{value} value read #{elem}" unless value == elem
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
