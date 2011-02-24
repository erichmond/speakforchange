class StatesController < ApplicationController
  def show
    @messages = Message.paginate :conditions => {:state => params[:id]}, :order => "id desc", :page => params[:page]
    @state = State.find_by_abbreviation(params[:id]) 
    @title = "#{@state.name} (#{@state.abbreviation})"
    @rss_title = "speakforchange.us messages from #{@state.name}"
    @rss_url = state_url(:id => @state.abbreviation)

    respond_to do |format|
      format.html {
        render :template => 'messages/index', :locals => {:rssurl => state_url(:id => @state.abbreviation)}
      }
      format.rss { render :template => 'messages/index.rss' }
    end
  end

  def index
    @states = State.all :order => 'name asc'
  end

end
