class StaticPagesController < ApplicationController
	def index
		@posts = Post.limit(3).order("created_at DESC")
		render "home"
	end

	def contactme
		ContactMailer.contactme(params).deliver
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


