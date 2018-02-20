module Drivy
  RENTALS = 'rentals'

  def self.start path
    car_list = Car.load_data "#{path}/data.json"
    rentals_dict = {}
    rents_list = car_list.select { |car| !car.rents.nil? }.map { |car| car.rents }.flatten
    rentals_dict[RENTALS] = rents_list.map(&:to_hash)
    rents_modif_list = rents_list.select { |rent| !rent.rental_modifications.nil? }.map { |rent| rent.rental_modifications.map(&:to_hash) }.flatten
    unless rents_modif_list.empty?
      rentals_dict[Rent::Rent::RENTAL_MODIFICATIONS] = rents_modif_list.map(&:to_hash)
    end
    compare_to_output "#{path}/output.json", rentals_dict
  end

  def self.compare_to_output(filename, rentals_dict)
    file = File.read filename
    output_dict = JSON.parse file
    compare_dict output_dict, rentals_dict
    puts "Success"
  rescue CompareError => err
    puts err
  end

  def self.compare_dict(expected, dict)
    expected.each { |key, value| compare_elem value, dict[key] }
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
        raise CompareError, "ERROR :: value expected #{value} value read #{elem}" unless value == elem
      end
    else
      raise CompareError, "ERROR :: value expected #{value} value read #{elem}"
    end
  end

  def self.sort_dict(elemA, elemB)
    if !elemA[Rent::Rent::ID].nil?
      value = (elemA[Rent::Rent::ID] <=> elemB[Rent::Rent::ID])
    else
      value = (elemA[Rent::Action::WHO] <=> elemB[Rent::Action::WHO])
    end
    value
  end

  class Error < RuntimeError
  end

  class CompareError < Error
  end
end
