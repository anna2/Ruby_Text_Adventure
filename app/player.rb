class Player
  attr_accessor :name, :location, :sanity

  def initialize(name)
      @name = name
      @location = :kitchen
      @sanity = 100
  end
  
  def insane?
    if @sanity <=0
      true
    end
  end
end