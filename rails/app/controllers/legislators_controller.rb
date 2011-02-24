class LegislatorsController < ApplicationController

  before_filter :find_legislator, :only => :show

  def index
    order = if params[:by_state]
              if request.path == '/representatives'
                "state asc, district asc, lastname asc"
              else
                "state asc, lastname asc"
              end
            else
              "lastname asc"
            end
    case request.path 
    when "/senators"
      @title = "The Senate"
      @legislators = Senator.all :order => order
    when "/representatives"
      @title = "The House of Representatives"
      @legislators = Representative.all :order => order
    end
  end

  def show
    @messages = @legislator.messages.all(:order => "deliveries.created_at desc").paginate :page => params[:page]
    @title = "All messages for #{@legislator.fullname}"
    @rss_url = legislator_url(@legislator)
  end

  private

  def find_legislator
    @legislator = Legislator.find params[:id]
  end
end
