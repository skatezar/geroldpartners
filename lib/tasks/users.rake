namespace :users do
  desc "Create an admin user"
  task create_admin: :environment do
    email = ENV['EMAIL'] || 'admin@example.com'
    password = ENV['PASSWORD'] || 'password123'

    user = User.find_or_initialize_by(email: email)
    user.password = password
    user.password_confirmation = password
    user.admin = true

    if user.save
      puts "Admin user created successfully!"
      puts "Email: #{user.email}"
      puts "Password: #{password}"
    else
      puts "Error creating admin user:"
      puts user.errors.full_messages.join(", ")
    end
  end
end
