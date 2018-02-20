module Drivy
  RENTALS = 'rentals'.freeze
  SUCCESS = 'Success'.freeze

  def self.start path
    car_list = Car.load_data "#{path}/data.json"
    rentals_dict = convert_car_list_to_dics car_list
    compare_to_output "#{path}/output.json", rentals_dict
  end

  def self.convert_car_list_to_dics(car_list)
    rentals_dict = {}
    rentals_dict[RENTALS] = regroup_rents_list car_list
    modif_list = regroup_modif_list car_list
    unless modif_list.empty?
      rentals_dict[Rent::Rent::RENTAL_MODIFICATIONS] = modif_list.map(&:to_hash)
    end
    rentals_dict
  end
  def self.regroup_rents_list(car_list)
    rents_list = car_list.reject { |car| car.rents.nil? }.map(&:rents).flatten
    rents_list.map(&:to_hash)
  end

  def self.regroup_modif_list(car_list)
    rents_list = car_list.reject { |car| car.rents.nil? }.map(&:rents).flatten
    rents_list.reject! { |rent| rent.rental_modifications.nil? }
    modif_list = rents_list.map do |rent|
      rent.rental_modifications.map(&:to_hash)
    end.flatten
  end

  def self.compare_to_output(filename, rentals_dict)
    file = File.read filename
    output_dict = JSON.parse file
    compare_dict output_dict, rentals_dict
    puts SUCCESS
  rescue CompareError => err
    puts err
  end

  def self.compare_dict(expected, dict)
    expected.each { |key, value| compare_elem value, dict[key] }
  end

  def self.compare_array(expected, array)
    if array.size == expected.size
      array.sort! { |elem_a, elem_b| sort_dict elem_a, elem_b }
      expected.sort! { |elem_a, elem_b| sort_dict elem_a, elem_b }
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
        raise CompareError, "ERROR :: value expected #{value} value read #{elem}" unless value == elem
      end
    else
      raise CompareError, "ERROR :: value expected #{value} value read #{elem}"
    end
  end

  def self.sort_dict(elem_a, elem_b)
    unless elem_a[Rent::Rent::ID].nil?
      return (elem_a[Rent::Rent::ID] <=> elem_b[Rent::Rent::ID])
    end
    (elem_a[Rent::Action::WHO] <=> elem_b[Rent::Action::WHO])
  end

  class Error < RuntimeError
  end

  class CompareError < Error
  end
end
