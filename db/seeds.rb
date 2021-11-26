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

      begin

        case model
        when 'Bake'
          baker_id = User.find_by(email: resource[:user_email]).id
          if baker_id && baker_id.is_a?(Integer)
            resource[:baker_id] = baker_id
            resource.delete(:user_email)

            category_id = Category.find_by(name: resource[:category_name]).id
            if category_id && category_id.is_a?(Integer)
              resource[:category_id] = category_id
              resource.delete(:category_name)
            else
              raise Exception.new("Couldn't find #{model}.category_id foreign key for: #{resource}")
            end
          else
            raise Exception.new("Couldn't find #{model}.baker_id foreign key for: #{resource}")
          end

        when 'BakeOrder'
          user_id = User.find_by(email: resource[:user_email]).id
          if user_id && user_id.is_a?(Integer)
            resource[:user_id] = user_id
            resource.delete(:user_email)
          else
            raise Exception.new("Couldn't find #{model}.user_id foreign key for: #{resource}")
          end
          

        when 'BakeJob'
          bake_id = Bake.find_by(created_at: resource[:bake_created_at]).id
          if bake_id && bake_id.is_a?(Integer)
            resource[:bake_id] = bake_id
            resource.delete(:bake_created_at)

            bake_order_id =  BakeOrder.find_by(created_at: resource[:bake_order_created_at]).id
            if bake_order_id && bake_order_id.is_a?(Integer)
              resource[:bake_order_id] = BakeOrder.find_by(created_at: resource[:bake_order_created_at]).id
              resource.delete(:bake_order_created_at)
            else
              raise Exception.new("Couldn't find #{model}.bake_order_id foreign key for: #{resource}")
            end
          else
            raise Exception.new("Couldn't find #{model}.bake_id foreign key for: #{resource}")
          end
        end

      
        model_object_id = Object.const_get(model).insert!(resource).first.values[0]
        if model_object_id.is_a?(Integer)
          model_object = Object.const_get(model).find(model_object_id)
        else
          raise Exception.new("Couldn't insert new object")
        end
      rescue Exception => e
        puts "Unable to create #{model} from : #{resource}"
        puts "Error full_message: #{e.message}"
      else
        if model_object.respond_to?(:name)
          puts "Created #{model} : #{model_object.name}"
        elsif model_object.respond_to?(:first_name)
          puts "Created #{model} : #{model_object.first_name}"
        else
          puts "Created #{model} from : #{resource}"
        end
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


  begin
    if bake_created_at.empty? || image_extension.empty?
      raise Exception.new("Couldn't regex match bake_created_at from filename #{basename}")
    else
      bake = Bake.find_by!(created_at: bake_created_at)
      bake.image.attach(io: File.open(image), filename: basename)
      puts "Attached image for #{bake.name}"
      
    end
  rescue Exception => e
    puts "Unable to find attach image for id: #{bake.id}"
    puts "Error full_message: #{e.full_message}"
  else
  end

end



