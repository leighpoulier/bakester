# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# if Category.count == 0
#   categories = %w[Biscuits Breads Cakes Cupcakes Pastries Pies\ &\ Tarts Slices]
#   categories.each do |category|
#     Category.create(name: category)
#     puts "Created category: #{category}"
#   end
# end

# if User.count == 0
#   User.create(email: 'leigh@test.com', password: 'password', admin: true, first_name: "Leigh", last_name: "Poulier")
#   puts "Created Admin User"
# end

# Categories

resources = {'Category' => 'categories', 'User' => 'users', 'Bake' => 'bakes', 'BakeOrder' => 'bake_orders', 'BakeJob' => 'bake_jobs'}

resources.each { |model, plural| 
  json = File.open(Rails.root.join('db','seed_data',"#{plural}.json"), "r").read

  puts "\nAttempting to parse json data for model: #{model}"

  begin
    resources_array = JSON.parse(json, {symbolize_names: true})
  rescue
    puts "Unable to parse json from \"#{json}\""
  else

    puts "Creating #{plural}"

    resources_array.each { |resource|

      resource.delete(:id)

      case model
      when 'Bake'
        resource[:baker_id] = User.find_by(email: resource[:user_email]).id
        resource.delete(:user_email)
        resource[:category_id] = Category.find_by(name: resource[:category_name]).id
        resource.delete(:category_name)

      when 'BakeOrder'
        resource[:user_id] = User.find_by(email: resource[:user_email]).id
        resource.delete(:user_email)

      when 'BakeJob'
        resource[:bake_id] = Bake.find_by(created_at: resource[:bake_created_at]).id
        resource.delete(:bake_created_at)
        resource[:bake_order_id] = BakeOrder.find_by(created_at: resource[:bake_order_created_at]).id
        resource.delete(:bake_order_created_at)
      end
      model_object_id = Object.const_get(model).insert!(resource).first.values[0]

      model_object = Object.const_get(model).find(model_object_id)

      if model_object.respond_to?(:name)
        puts "Created #{model} : #{model_object.name}"
      elsif model_object.respond_to?(:first_name)
        puts "Created #{model} : #{model_object.first_name}"
      else
        puts "Created #{model} from : #{resource}"
      end
    }

    puts "Created #{Object.const_get(model).count} #{plural}"

  end
}


images = Dir[Rails.root.join('db','seed_data','images','bake_*.*')]
puts "Found #{images.length} images"


images.each do |image|

  basename = File.basename(image)

  regex = /bake_(?<bake_created_at>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}\:\d{2}\.\d{1,6})\.(?<image_extension>[a-z]{1,4})/

  matches = basename.match(regex)
  bake_created_at = matches[:bake_created_at]
  image_extension = matches[:image_extension]

  bake = Bake.find_by(created_at: bake_created_at)

  if bake
  
    bake.image.attach(io: File.open(image), filename: basename)
    puts "Attached image for #{bake.name}"

  else
    puts "Unable to find matching image for id: #{bake.id}"
  end

end



