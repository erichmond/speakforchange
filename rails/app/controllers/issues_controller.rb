class IssuesController < ApplicationController
  before_filter :find_issue, :only => :show
  def index
    @issues = Issue.paginate :order => "issues.alphabetical_title asc", :page => params[:page]
  end

  def show
    @messages = @issue.messages(:order => "deliveries.created_at desc").paginate :page => params[:page]
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new params[:issue]
    if @issue.save
      flash[:notice] = "Your issue '#{@issue.title}' has been created and assigned the extension #{@issue.extension}"
      redirect_to @issue
    else
      render :action => 'new'
    end
  end


  def find_issue
    @issue = Issue.find params[:id]
  end
end
