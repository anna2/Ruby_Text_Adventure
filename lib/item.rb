require_relative '../files'

class Item
  attr_accessor :tag, :name, :description, :sanity_points
      
    def initialize(tag, name, description, sanity_points)
      @tag = tag
      @name = name
      @description = description
      @sanity_points = sanity_points
      @room = room
    end
    
    def item_description
        @description
    end 
end 