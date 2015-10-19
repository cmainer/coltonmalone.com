class PagesController < ApplicationController
  def index
    render "home"
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
