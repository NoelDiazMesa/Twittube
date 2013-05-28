class UsuariosController < ApplicationController
  before_filter :admin_user,  only: :destroy
  # GET /usuarios
  # GET /usuarios.json
  def index
    #@usuario = Usuario.all
    @usuarios = Usuario.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usuarios }
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
    @usuario = Usuario.find(params[:id])

    #@title = @usuario.username

    @microposts = @usuario.microposts
    @microposts = @microposts.paginate(page: params[:page])
  end 

=begin
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usuario }
    end
=end

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
      if @usuario.update_attributes(params[:usuario]) # Cambie params[:usuario] por user_params
        flash[:success] = "Profile updated"
        sign_in @usuario
        redirect_to @usuario
        format.html { redirect_to @usuario, notice: 'Usuario was successfully updated.' }
        format.json { head :no_content }
      else
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
    flash[:success] = "User destroyed."
    # redirect_to usuarios_url
    respond_to do |format|
      format.html { redirect_to usuarios_url }
      format.json { head :no_content }
    end
  end

  private

    def user_params
      params.require(:usuario).permit(:username, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    def correct_user
      @user = Usuario.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
