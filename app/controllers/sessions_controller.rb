class SessionsController < ApplicationController
  def new
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.find_by_email(params[:session][:email].downcase)
    if @usuario && @usuario.authenticate(params[:session][:password])
      sign_in @usuario
      redirect_to @usuario
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end