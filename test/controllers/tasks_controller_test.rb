require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @task = tasks(:one)
    post login_path, params: { email: @user.email, password: 'password123' }
  end

  # Test index
  test "should get index" do
    get tasks_path
    assert_response :success
    assert_select "h1", /Mis Tareas/
  end

  # Test show
  test "should show task" do
    get task_path(@task)
    assert_response :success
  end

  test "should not show other user's task" do
    other_user = users(:two)
    other_task = other_user.tasks.create!(title: "Other Task", due_date: 1.day.from_now, status: :pending, priority: :medium)
    
    delete logout_path
    post login_path, params: { email: other_user.email, password: 'password123' }
    
    get task_path(@task)
    assert_response :not_found
  end

  # Test new
  test "should get new" do
    get new_task_path
    assert_response :success
  end

  # Test create
  test "should create task" do
    assert_difference('Task.count') do
      post tasks_path, params: {
        task: {
          title: "Nueva tarea",
          description: "Descripción de prueba",
          due_date: 1.day.from_now,
          status: :pending,
          priority: :medium
        }
      }
    end
    assert_redirected_to tasks_path
  end

  test "should not create task without title" do
    assert_no_difference('Task.count') do
      post tasks_path, params: {
        task: {
          description: "Sin título",
          due_date: 1.day.from_now,
          status: :pending,
          priority: :medium
        }
      }
    end
    assert_response :unprocessable_entity
  end

  # Test edit
  test "should get edit" do
    get edit_task_path(@task)
    assert_response :success
  end

  # Test update
  test "should update task" do
    patch task_path(@task), params: {
      task: { title: "Título actualizado" }
    }
    assert_redirected_to tasks_path
    @task.reload
    assert_equal "Título actualizado", @task.title
  end

  # Test destroy
  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete task_path(@task)
    end
    assert_redirected_to tasks_path
  end

  # Test autenticación
  test "should redirect to login if not authenticated" do
    delete logout_path
    get tasks_path
    assert_redirected_to login_path
  end

  # Test filtros
  test "should filter tasks by status" do
    get tasks_path, params: { status: 'pending' }
    assert_response :success
  end

  # Test búsqueda
  test "should search tasks by title" do
    Task.create!(title: "Proyecto Alpha", due_date: 2.days.from_now, user: @user, status: :pending, priority: :medium)
    Task.create!(title: "Revisión Beta", due_date: 3.days.from_now, user: @user, status: :pending, priority: :medium)

    get tasks_path, params: { q: 'Alpha' }
    assert_response :success
    assert_select 'td strong', text: 'Proyecto Alpha'
    assert_select 'td strong', text: 'Revisión Beta', count: 0
  end

  test "should search combined with status filter" do
    Task.create!(title: "Reporte Mensual", due_date: 1.day.from_now, user: @user, status: :pending, priority: :low)
    Task.create!(title: "Reporte Mensual", due_date: 1.day.from_now, user: @user, status: :completed, priority: :low)

    get tasks_path, params: { q: 'Reporte', status: 'pending' }
    assert_response :success
    # Debe mostrar solo la tarea pendiente
    assert_select 'td', text: /Reporte Mensual/, minimum: 1
  end
end