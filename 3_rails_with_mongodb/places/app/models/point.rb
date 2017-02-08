class Point
  attr_accessor :latitude, :longitude

  def initialize(params)
    if params[:coordinates]
      @latitude = params[:coordinates][1]
      @longitude = params[:coordinates][0]
    else
      @latitude = params[:lat]
      @longitude = params[:lng]
    end
  end

  def to_hash
    params = {}
    params[:type] = "Point"
    params[:coordinates] = [@longitude, @latitude]
    params
  end

end