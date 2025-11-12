class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  
  def new
    # Muestra el formulario de login
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: "¡Bienvenido de vuelta, #{user.name}!"
    else
      flash.now[:alert] = "Email o contraseña incorrectos"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "¡Has cerrado sesión correctamente!"
  end
end
