class SearchController < ApplicationController

  def index
    @search_field = params[:search_field]
    @messages = Message.search @search_field, :page => params[:page]
  end

end
