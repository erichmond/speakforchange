class HomeController < ApplicationController

  def index
    @messages = Message.recent(20)
  end

  def nothing
    render :nothing => true
  end
end
