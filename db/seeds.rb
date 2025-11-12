# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding demo data..."

demo_user = User.find_or_initialize_by(email: "ana@ejemplo.com")
demo_user.name = "Ana García"
demo_user.password = "password123"
demo_user.password_confirmation = "password123"
demo_user.save!

%w[Trabajo Personal Urgente].each do |cat_name|
  demo_user.categories.find_or_create_by!(name: cat_name)
end

unless demo_user.tasks.exists?(title: "Tarea de ejemplo")
  demo_user.tasks.create!(
    title: "Tarea de ejemplo",
    description: "Revisa la app y marca esta tarea como completada",
    due_date: 2.days.from_now,
    status: :pending,
    priority: :medium,
    category: demo_user.categories.first
  )
end

puts "Seed completado. Usuario demo: ana@ejemplo.com / password123"
