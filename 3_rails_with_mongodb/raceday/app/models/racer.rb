class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    self.mongo_client['racers']
  end

  def self.all(prototype={}, sort={}, skip=0, limit=nil)
    result = collection.find(prototype).sort(sort).skip(skip)
    if limit then result.limit(limit) else result end
  end

  def initialize(params={})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i
  end

  def self.find(id)
    result = collection.find(_id: BSON.ObjectId(id)).first
    result.nil? ? nil : Racer.new(result)
  end

  def save
    result = self.class.collection.insert_one(_id:@id, number:@number, first_name:@first_name, last_name:@last_name, gender:@gender, group:@group, secs:@secs)
    @id = result.inserted_id.to_s
  end

  def update(params)
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i

    params.slice!(:number, :first_name, :last_name, :gender, :group, :secs)

    self.class.collection.find(_id: BSON.ObjectId(@id))
    .update_one(:$set => {number:@number, first_name:@first_name, last_name:@last_name, gender:@gender, group:@group, secs:@secs})

  end

  def destroy
    self.class.collection.find(number: @number).delete_one
  end

  def persisted?
    !@id.nil?
  end

  def created_at
    nil
  end

  def updated_at
    nil
  end

  def self.paginate(params)
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 30).to_i

    records = all({}, {number: 1}, (page - 1) * per_page, per_page).map {|r| Racer.new(r)}
    total = all.count

    WillPaginate::Collection.create(page, per_page, total) do |pager|
      pager.replace(records)
    end
  end
end
