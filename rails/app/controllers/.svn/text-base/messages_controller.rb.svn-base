class MessagesController < ApplicationController

  before_filter :find_message, :except => [:index, :validate_edit]

  def index
    @messages = Message.paginate :order => "created_at desc", :page => params[:page]
  
    respond_to do |format|
      format.html
      format.rss  { render :layout => false }
    end
  end

  def show

    @title = "Message ##{@message.id}" 
    @title += " - #{@message.title}" if @message.title
    respond_to do |format|
      format.js { render :partial => 'message', :object => @message }
      format.html
    end
  end

  def validate_edit
    if params[:password] && params[:zipcode] && (m = Message.find_by_password(params[:password])) && m.zipcode == params[:zipcode]
      @message = m
      render :action => :edit, :id => m, :message => {:password => params[:password]}
    else
      flash[:notice] = "Sorry, we couldn't find a message for that zipcode and password"
      redirect_to messages_path
    end
  end

  def edit
  end

  def update
    if params[:message][:password] != @message.password
      flash[:notice] = "Sorry, invalid password"
      redirect_to edit_message_path(@message)
    else
      # a hack. Ensure tag_list has no more than 5 tags
      if !params[:message][:tag_list].blank?
        params[:message][:tag_list] = params[:message][:tag_list].split(',')[0,5]
      end
      if @message.update_attributes params[:message]
        flash[:notice] = "Message edited!"
        redirect_to :action => :show
      else
        render :action => 'edit'
      end
    end
  end

  def find_message
    @message = Message.find params[:id]
  end
end
