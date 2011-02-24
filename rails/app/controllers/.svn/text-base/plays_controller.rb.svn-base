class PlaysController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    Play.create :ip_address => request.remote_ip, :message_id => params[:message_id]
    render :nothing => true
  end
end
