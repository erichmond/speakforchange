=begin
===============================================================================
 http://www.speakforchange.us
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 3 of the License.
   
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 http://www.gnu.org/licenses/gpl-3.0.txt
  
 Author(s): Carlos Lenz, carlos@newvo.com
 File: startup.rb
 Created On: Thu Mar 26 11:26:06 EDT 2009
===============================================================================
=end


unless defined? Adhearsion
  if File.exists? File.dirname(__FILE__) + "/../adhearsion/lib/adhearsion.rb"
    # If you wish to freeze a copy of Adhearsion to this app, simply place a copy of Adhearsion
    # into a folder named "adhearsion" within this app's main directory.
    require File.dirname(__FILE__) + "/../adhearsion/lib/adhearsion.rb"
  else  
    require 'rubygems'
    gem 'adhearsion', '>= 0.7.999'
    require 'adhearsion'
  end
end

Adhearsion::Configuration.configure do |config|
  
  # Supported levels (in increasing severity) -- :debug < :info < :warn < :error < :fatal
  config.logging :level => :debug
  
  # Whether incoming calls be automatically answered. Defaults to true.
  config.automatically_answer_incoming_calls = false
  
  # Whether the other end hanging up should end the call immediately. Defaults to true.
  # config.end_call_on_hangup = false
  
  # Whether to end the call immediately if an unrescued exception is caught. Defaults to true.
  # config.end_call_on_error = false
  
  # By default Asterisk is enabled with the default settings
  config.enable_asterisk
  config.asterisk.enable_ami :host => "127.0.0.1", :username => "admin", :password => "123", :events => true
  
  # config.enable_drb
  
  # Streamlined Rails integration! The first argument should be a relative or absolute path to 
  # the Rails app folder with which you're integrating. The second argument must be one of the 
  # the following: :development, :production, or :test.
  
  directory = File.dirname(__FILE__)
  
  if File.directory?(directory + "/../../rails")
    path = directory + "/../../rails"
    env = :development
  elsif File.directory?(directory + "/../../../../rails/current")
    path = directory + "/../../../../rails/current"
    env = :production
  else
    ahn_log.fatal "No match found for rails application! " + directory
		raise Exception.new("No match found for rails application.  File.dirname = #{directory}.  Fatal Error.")
  end
  
  config.enable_rails :path => path, :env => env
  
  # Note: You CANNOT do enable_rails and enable_database at the same time. When you enable Rails,
  # it will automatically connect to same database Rails does and load the Rails app's models.

end

Adhearsion::Initializer.start_from_init_file(__FILE__, File.dirname(__FILE__) + "/..")
