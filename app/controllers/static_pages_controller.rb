class StaticPagesController < ApplicationController
	def index
		@posts = Post.limit(3).order("created_at DESC")
		render "home"
	end
end
