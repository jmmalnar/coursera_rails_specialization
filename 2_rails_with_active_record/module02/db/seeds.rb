# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all

user1 = User.create!(username: 'Fiorina', password_digest: 'password')
user2 = User.create!(username: 'Trump', password_digest: 'password')
user3 = User.create!(username: 'Carson', password_digest: 'password')
user4 = User.create!(username: 'Clinton', password_digest: 'password')

Profile.create!(gender: 'female', birth_year: 1954, first_name: 'Carly', last_name: 'Fiorina', user_id: user1.id)
Profile.create!(gender: 'male', birth_year: 1946, first_name: 'Donald', last_name: 'Trump', user_id: user2.id)
Profile.create!(gender: 'male', birth_year: 1951, first_name: 'Ben', last_name: 'Carson', user_id: user3.id)
Profile.create!(gender: 'female', birth_year: 1947, first_name: 'Hillary', last_name: 'Clinton', user_id: user4.id)

User.all.each do |user|
  TodoList.create!(list_name: "#{user.username} list", list_due_date: Date.today + 1.year, user_id: user.id)
end

TodoList.all.each do |list|
  i = 1
  5.times do
    TodoItem.create!(due_date: Date.today + 1.year, title: "Todo Item #{i}", description: 'Here is the description', completed: false, todo_list_id: list.id)
    i += 1
  end
end