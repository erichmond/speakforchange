class TagsController < ApplicationController

  def index
    @tags = Tag.all :order => "name asc"
  end

  def show
    @tag = Tag.find params[:id]
    @messages = Message.paginate :joins => {:taggings => :tag},
      :conditions => ["tags.id = ?", @tag.id],
      :page => params[:page]
    @title = "All messages tagged <span class='tag'>#{@tag.name}</span>"
    @rss_title = "speakforchange.us messages tagged \"#{@tag.name}\""
    @rss_url = tag_url(@tag)
    
    respond_to do |format|
      format.html {
        render :template => 'messages/index', :locals => {:rssurl => tag_url(@tag)}
      }
      format.rss { render :template => 'messages/index.rss' }
    end

  end

end
