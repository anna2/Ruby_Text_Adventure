require_relative '../files'

class Item
  attr_accessor :symbol_name, :name, :description, :sanity_points
      
  def initialize(symbol_name, name, description, sanity_points)
  	@symbol_name = symbol_name
    @name = name
    @description = description
    @sanity_points = sanity_points
  end
end 