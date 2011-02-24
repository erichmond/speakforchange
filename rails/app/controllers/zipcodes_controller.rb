class ZipcodesController < ApplicationController
  def index
  end

  def show
    @messages = Message.paginate :all, :conditions => {:zipcode => params[:id]}, :order => "id desc", :page => params[:page]
    @title = "All messages for zip code #{params[:id]}"
    @rss_title = "speakforchange.us messages from zipcode #{params[:id]}"
    @rss_url = zipcode_url(:id => params[:id])

    respond_to do |format|
      format.html {
        render :template => 'messages/index', :locals => {:rssurl => zipcode_url(:id => params[:id])}
      }
      format.rss { render :template => 'messages/index.rss' }
    end



  end

end
