class UsuariosController < ApplicationController
  #before_filter :signed_in_user, 
  #             only: [:index, :edit, :update, :destroy, :following, :followers]
  #before_filter :correct_user,   only: [:edit, :update]
  #before_filter :admin_user,     only: :destroy
 
  def index
    @usuarios = Usuario.paginate(page: params[:page])
  end
  
  def create
    @usuario = Usuario.new(params[:usuario])
    if @usuario.save
      sign_in @usuario
      flash[:success] = "Bienvenido a Twittube!"
      redirect_to @usuario
    else
      render 'new'
    end
  end
  
  def show
    @usuario = Usuario.find(params[:id])
    @microposts = @usuario.microposts.paginate(page: params[:page])
  end

  
  def new
    @usuario = Usuario.new
  end
  
  def edit
    @usuario = Usuario.find(params[:id])
  end

  def update
    @usuario = Usuario.find(params[:id])
    if @usuario.update_attributes(params[:usuario])
      flash[:success] = "Profile updated"
      sign_in @usuario
      redirect_to @usuario
    else
      render 'edit'
    end
  end
  
  def destroy
    Usuario.find(params[:id]).destroy
    flash[:success] = "Usuario destroyed."
    redirect_to usuarios_path
  end

  def following
    @title = "Following"
    @usuario = Usuario.find(params[:id])
    @usuarios = @usuario.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @usuario = Usuario.find(params[:id])
    @usuarios = @usuario.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
    def user_params
      params.require(:usuario).permit(:username, :email, :password,
                                   :password_confirmation)
    end
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @usuario = Usuario.find(params[:id])
      redirect_to(root_path) unless current_user?(@usuario)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
