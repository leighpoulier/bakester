# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Category.count == 0
  categories = %w[Biscuits Breads Cakes Cupcakes Pastries Pies\ &\ Tarts Slices]
  categories.each do |category|
    Category.create(name: category)
    puts "Created category: #{category}"
  end
end

if User.count == 0
  User.create(email: 'leigh@test.com', password: 'password', admin: true, first_name: "Leigh", last_name: "Poulier")
  puts "Created Admin User"
end