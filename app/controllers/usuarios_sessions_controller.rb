class UsuariosSessionsController < ApplicationController
	def new
  	@usuario = Usuario.new
  end
  def create
  	user = Usuario.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  def destroy
  	logout
  	redirect_to(:usuarios, message: "Logged out")
  end
end
