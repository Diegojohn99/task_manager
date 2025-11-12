require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  setup do
    @task = tasks(:one)
    @user = users(:one)
  end

  # Pruebas de presencia
  test "should not save task without title" do
    task = Task.new(description: "Test", due_date: 1.day.from_now, user: @user)
    assert_not task.save, "Guardó tarea sin título"
  end

  test "should not save task without due_date" do
    task = Task.new(title: "Test Task", user: @user)
    assert_not task.save, "Guardó tarea sin fecha de vencimiento"
  end

  test "should not save task without user" do
    task = Task.new(title: "Test Task", due_date: 1.day.from_now)
    assert_not task.save, "Guardó tarea sin usuario"
  end

  # Pruebas de longitud
  test "should not save task with title too short" do
    task = Task.new(title: "ab", due_date: 1.day.from_now, user: @user)
    assert_not task.save, "Guardó tarea con título muy corto"
  end

  test "should not save task with title too long" do
    task = Task.new(title: "a" * 101, due_date: 1.day.from_now, user: @user)
    assert_not task.save, "Guardó tarea con título muy largo"
  end

  test "should save task with valid data" do
    task = Task.new(title: "Valid Task", due_date: 1.day.from_now, user: @user, status: :pending, priority: :medium)
    assert task.save, "No guardó tarea válida"
  end

  # Pruebas de métodos
  test "overdue? returns true for past due dates" do
    task = Task.create!(title: "Overdue Task", due_date: 1.day.ago, user: @user, status: :pending, priority: :high)
    assert task.overdue?, "No detectó tarea vencida"
  end

  test "overdue? returns false for future due dates" do
    task = Task.create!(title: "Future Task", due_date: 1.day.from_now, user: @user, status: :pending, priority: :high)
    assert_not task.overdue?, "Detectó tarea futura como vencida"
  end

  test "overdue? returns false for completed tasks" do
    task = Task.create!(title: "Completed Task", due_date: 1.day.ago, user: @user, status: :completed, priority: :high)
    assert_not task.overdue?, "Detectó tarea completada como vencida"
  end

  # Pruebas de scopes
  test "overdue scope returns only overdue tasks" do
    Task.create!(title: "Overdue", due_date: 1.day.ago, user: @user, status: :pending, priority: :high)
    Task.create!(title: "Future", due_date: 1.day.from_now, user: @user, status: :pending, priority: :high)
    
    overdue_tasks = Task.overdue
    assert_equal 1, overdue_tasks.count, "Scope overdue no funciona correctamente"
  end

  test "by_priority scope orders by priority" do
    Task.create!(title: "Low Priority", due_date: 1.day.from_now, user: @user, status: :pending, priority: :low)
    Task.create!(title: "High Priority", due_date: 1.day.from_now, user: @user, status: :pending, priority: :high)
    
    tasks = Task.by_priority
    assert_equal :high, tasks.first.priority.to_sym, "No ordena correctamente por prioridad"
  end

  test "search finds by title" do
    Task.create!(title: "Proyecto Alpha", due_date: 2.days.from_now, user: @user, status: :pending, priority: :medium)
    Task.create!(title: "Revisión Beta", due_date: 3.days.from_now, user: @user, status: :pending, priority: :medium)
    results = Task.search("Alpha")
    assert_equal 1, results.count
    assert_equal "Proyecto Alpha", results.first.title
  end

  test "search finds by description" do
    Task.create!(title: "Tarea X", description: "contiene PalabraClave", due_date: 1.day.from_now, user: @user, status: :pending, priority: :low)
    Task.create!(title: "Tarea Y", description: "otro texto", due_date: 1.day.from_now, user: @user, status: :pending, priority: :low)
    results = Task.search("palabraclave")
    assert_equal 1, results.count
    assert_equal "Tarea X", results.first.title
  end
end