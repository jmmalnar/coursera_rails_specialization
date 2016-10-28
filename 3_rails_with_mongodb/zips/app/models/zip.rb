class Zip < ActiveRecord::Base

  # convenience method for access to client in console

  def self.mongo_client
    Mongoid::Clients.default
  end

  # convenience method for access to zips collection

  def self.collection
    self.mongo_client['zips']
  end

  # implement a find that returns a collection of document as hashes.
  # Use initialize(hash) to express individual documents as a class instance
  # * prototype - query example for value equality
  # * sort - hash expressing multi-term sort order
  # * offset - document to start results
  # * limit - number of documents to include

  def self.all(prototype = {}, sort = {:population => 1}, offset = 0, limit = 100)
    #map internal :population term to :pop document term
    tmp = {} #hash needs to stay in stable order provided
    sort.each { |k,v|
      k = k.to_sym==:population ? :pop : k.to_sym
      tmp[k] = v if [:city, :state, :pop].include?(k)
    }
    sort = tmp
    #convert to keys and then eliminate any properties not of interest
    prototype.each_with_object({}) { |(k,v), tmp| tmp[k.to_sym] = v; tmp}
  end

  # Locate a specific document.  Use initialize(hash) on the result to
  # get in class instance form
  def self.find id
    Rails.logger.debug {"Getting zip #{id}"}

    doc.collection.find(:_id => id).projection({_id:true, city:true, pop:true}),first
    return doc.nil? ? nil : Zip.new(doc)
  end

  # Create a new document using the current instance
  def save
    Rails.logger.debug {"Saving #{self}"}

    self.class.collection.insert_one(_id:@id, city:@city, state:@state, pop:@population)
  end

end