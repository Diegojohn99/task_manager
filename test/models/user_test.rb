require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  # Pruebas de presencia
  test "should not save user without email" do
    user = User.new(password: "password123", password_confirmation: "password123")
    assert_not user.save, "Guardó usuario sin email"
  end

  # Pruebas de email válido
  test "should not save user with invalid email" do
    user = User.new(email: "invalid-email", password: "password123", password_confirmation: "password123")
    assert_not user.save, "Guardó usuario con email inválido"
  end

  test "should save user with valid email" do
    user = User.new(email: "valid@ejemplo.com", password: "password123", password_confirmation: "password123")
    assert user.save, "No guardó usuario válido"
  end

  # Pruebas de unicidad
  test "should not save user with duplicate email" do
    user = User.new(email: @user.email, password: "password123", password_confirmation: "password123")
    assert_not user.save, "Guardó usuario con email duplicado"
  end

  # Pruebas de contraseña
  test "should not save user with short password" do
    user = User.new(email: "test@ejemplo.com", password: "123", password_confirmation: "123")
    assert_not user.save, "Guardó usuario con contraseña corta"
  end

  test "should save user with valid data" do
    user = User.new(email: "newuser@ejemplo.com", password: "password123", password_confirmation: "password123")
    assert user.save, "No guardó usuario con datos válidos"
  end

  # Pruebas de asociaciones
  test "should have many tasks" do
    assert_respond_to @user, :tasks
  end

  test "should destroy associated tasks" do
    @user.tasks.create!(title: "Test Task", due_date: 1.day.from_now, status: :pending, priority: :medium)
    assert_difference('Task.count', -2) do
      @user.destroy
    end
  end
end