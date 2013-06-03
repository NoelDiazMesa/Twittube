class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @usuario = Usuario.find(params[:relationship][:followed_id])
    current_user.follow!(@usuario)
    redirect_to @usuario
  end

  def destroy
    @usuario = Relationship.find(params[:id]).followed
    current_user.unfollow!(@usuario)
    redirect_to @usuario
  end
end