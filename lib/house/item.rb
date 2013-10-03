require_relative '../files'

class Item
  attr_accessor :name, :description, :sanity_points
      
    def initialize(name, description, sanity_points)
      @name = name
      @description = description
      @sanity_points = sanity_points
    end
    
    def item_description
        @description
    end 
end 