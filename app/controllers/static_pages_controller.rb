class StaticPagesController < ApplicationController
	def index
		@posts = Post.limit(3).order("created_at DESC")
		render "home"
	end

	def contactme
		if ContactMailer.contactme(params).deliver
			respond_to do |format|
	      format.js {}
	    end
	  end

		# @posts = Post.limit(3).order("created_at DESC")
		# redirect_to root_path
	end

	def path
		begin
			erb = ERB.new(File.join("pages", params[:path]))
			render erb.result
		rescue ActionView::MissingTemplate => e
			raise ActionController::RoutingError.new("Not found")
		end
	end
end


