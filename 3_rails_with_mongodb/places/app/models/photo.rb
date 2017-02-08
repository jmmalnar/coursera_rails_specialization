class Photo
  include ActiveModel::Model

  attr_accessor :id, :location, :contents, :place

  def self.mongo_client
    Mongoid::Clients.default
  end

  def initialize params = {}
    unless params == {}
      @id = params[:_id].to_s
      if params[:metadata].present?
        @location = Point.new(params[:metadata][:location]) if params[:metadata][:location]
        @place = params[:metadata][:place]
      end

      params[:contents].present? ? @contents = params[:contents] : nil
    else
      @id = nil
    end
  end

  def persisted?
    !@id.nil?
  end

  def save
    unless persisted?
      description = {}
      description[:content_type] = "image/jpeg"
      gps = EXIFR::JPEG.new(@contents).gps
      @contents.rewind
      @location = Point.new(:lng => gps.longitude, :lat => gps.latitude)
      description[:metadata] = {:location => @location.to_hash,
                                :place => @place}

      grid_file = Mongo::Grid::File.new(contents.read, description)

      inserted = self.class.mongo_client.database.fs.insert_one(grid_file)
      @id = inserted.to_s
    else
      doc = self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(@id)).first
      doc[:metadata][:location] = @location.to_hash
      doc[:metadata][:place] = @place

      self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(@id)).update_one(doc)
    end
  end

  def self.all offset = 0, limit = nil
    result = mongo_client.database.fs.find.skip(offset)

    result = result.limit(limit) unless limit.nil?
    result.map {|doc| Photo.new(doc)}
  end

  def self.find id
    result = mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(id)).first

    result = Photo.new(result) unless result.nil?
  end

  def contents
    if persisted?
      doc = self.class.mongo_client.database.fs.find_one(:_id => BSON::ObjectId.from_string(@id))

      if doc
        buffer = ""
        doc.chunks.reduce([]) do |x, chunk|
          buffer << chunk.data.data
        end
        return buffer
      end
    else
      @contents
    end
  end

  def destroy
    self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId::from_string(@id)).delete_one if @id
  end

  def find_nearest_place_id max_meters
    doc = Place.near(@location, max_meters) if @location

    doc.first[:_id]
  end

  def place
    Place.find @place if @place
  end

  def place=(value)
    if value
      if value.instance_of? Place
        @place = value.id
      else
        @place = BSON::ObjectId.from_string(value)
      end
    else
      @place = nil
    end
  end

  def self.find_photos_for_place id
    if id.instance_of? String
      id = BSON::ObjectId.from_string(id)
    else
      id = id.to_s
    end

    result = mongo_client.database.fs.find("metadata.place" => id)
    if result.count == 0
      result = mongo_client.database.fs.find("metadata.place" => id.to_s)
    end
    result
  end

end