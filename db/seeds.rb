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
      existing_model_object = Object.const_get(model).find(resource[:id])
      unless existing_model_object
        Object.const_get(model).insert!(resource)
      end
      model_object = Object.const_get(model).find(resource[:id])

      if model == 'Bake'
        unless model_object.image.attached?
          file_matches = Dir[Rails.root.join('db', 'seed_data', 'images', "bake_#{model_object.id}.*")]
          if file_matches.length == 1
            image_path = file_matches[0]
            image_file = File.basename(image_path)
            model_object.image.attach(io: File.open(image_path), filename: image_file)
            puts "Attached image for #{model_object.name}"
          else
            puts "Unable to find matching image for id: #{model_object.id}"
          end
        end
      end

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



