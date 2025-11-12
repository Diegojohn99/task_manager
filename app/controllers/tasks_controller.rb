class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = current_user.tasks
    @tasks = @tasks.search(params[:q])
    @tasks = @tasks.where(status: params[:status]) if params[:status].present?
    @tasks = @tasks.where(priority: params[:priority]) if params[:priority].present?
    @tasks = @tasks.where(category_id: params[:category_id]) if params[:category_id].present?
    @tasks = @tasks.order(due_date: :asc).page(params[:page]).per(10)
    @categories = current_user.categories
  end

  def show
  end

  def new
    @task = current_user.tasks.new
    @categories = current_user.categories
  end

  def create
    @task = current_user.tasks.new(task_params)
    
    if @task.save
      redirect_to tasks_path, notice: '¡Tarea creada exitosamente!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = current_user.categories
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: '¡Tarea actualizada exitosamente!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: '¡Tarea eliminada exitosamente!'
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status, :priority, :category_id)
  end
end