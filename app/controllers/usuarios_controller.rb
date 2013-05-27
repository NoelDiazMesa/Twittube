class UsuariosController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  # GET /usuarios
  # GET /usuarios.json
  def index
    #@usuarios = Usuario.all
    @usuarios = Usuario.paginate(page: params[:page])
=begin
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usuarios }
    end
=end
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
    @usuario = Usuario.find(params[:id])
    @title = @usuario.username
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usuario }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.json
  def new
    @usuario = Usuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @usuario }
    end
  end

  # GET /usuarios/1/edit
  def edit
    @usuario = Usuario.find(params[:id])
  end

  # POST /usuarios
  # POST /usuarios.json
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

  # PUT /usuarios/1
  # PUT /usuarios/1.json

  def update
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(usuario_params)
        flash[:success] = "Profile updated"
        sign_in @usuario
        redirect_to @usuario
        format.html { redirect_to @usuario, notice: 'El usuario se ha creado satisfactoriamente' }
        format.json { head :no_content }
      else
        render 'edit'
        format.html { render action: "edit" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy

    respond_to do |format|
      format.html { redirect_to usuarios_url }
      format.json { head :no_content }
    end
  end

  def edit
    @user = Usuario.find(params[:id])
  end
  private
     def user_params
      params.require(:usuario).permit(:username, :email, :password,
                                   :password_confirmation)
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    def correct_user
      @user = Usuario.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
