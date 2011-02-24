# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  #before_filter :authenticate
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4f6083c8abe6572bfcb6939eb2e67886'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  #after_filter :convert_unconverted_mp3s

  protected

  # deprecated. see Message#mp3_audio_path
  def convert_unconverted_mp3s
    logger.debug "Search for unconverted"
    Message.process_unconverted
  end
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "gophoenix" && password == "g0ph0enix"
    end
  end


  def state_links
    STATES.each_slice(2).map {|name, abbrev| link_to( "#{name.split(" ").map {|w| w.capitalize}.join(' ')} #{abbrev}", state_path(:id => abbrev) )}
  end

  def states
    STATES
  end

  def capitalize_state_name(x)
    x.split(" ").map {|w| w.capitalize}.join(' ')
  end

  STATES = %W{ ALABAMA AL ALASKA AK ARIZONA AZ ARKANSAS AR CALIFORNIA CA COLORADO CO CONNECTICUT CT DELAWARE DE FLORIDA FL GEORGIA GA HAWAII HI IDAHO ID ILLINOIS IL INDIANA IN IOWA IA KANSAS KS KENTUCKY KY LOUISIANA LA MAINE ME MARYLAND MD MASSACHUSETTS MA MICHIGAN MI MINNESOTA MN MISSISSIPPI MS MISSOURI MO MONTANA MT NEBRASKA NE NEVADA NV NEW\ HAMPSHIRE NH NEW\ JERSEY NJ NEW\ MEXICO NM NEW\ YORK NY NORTH\ CAROLINA NC NORTH\ DAKOTA ND OHIO OH OKLAHOMA OK OREGON OR PENNSYLVANIA PA RHODE\ ISLAND RI SOUTH\ CAROLINA SC SOUTH\ DAKOTA SD TENNESSEE TN TEXAS TX UTAH UT VERMONT VT VIRGINIA VA WASHINGTON WA WEST\ VIRGINIA WV WISCONSIN WI WYOMING WY }
  helper_method :states
  helper_method :state_links

  # From Rails Cookbook (ORA) Recipe 15.20. Automatically sending error messages
  # to your email
  def log_error(exception)
    super
    return unless  RAILS_ENV == 'production'
    logger.info "LOG ERROR: #{exception}"
    Notification.deliver_error_message(exception,
                                       clean_backtrace(exception),
                                       #session.instance_variable_get("@data"),
                                       params,
                                       request.env)
  end

end
