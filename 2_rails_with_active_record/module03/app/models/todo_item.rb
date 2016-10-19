class TodoItem < ActiveRecord::Base

  def self.count_of_completed_items
    TodoItem.where(:completed => true).count
  end

end
