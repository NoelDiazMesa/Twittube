class StaticPagesController < ApplicationController
	def home
    	if signed_in?
      		@micropost  = current_user.microposts.build
      		#@feed_items = current_user.feed.paginate(page: params[:page])
    	end
  	end
	def form
		@name = params[:nombre_usuario]
		@nombre = Form.all
		@ejemplo = Form.create({name: @name})
	end
end
