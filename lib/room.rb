require_relative '../files'


class Room
  attr_accessor :tag, :description, :links, :inventory

  def initialize(tag, description, links, inventory)
    @tag = tag
    @description = description
    @links = links
    @inventory = inventory
  end
end
