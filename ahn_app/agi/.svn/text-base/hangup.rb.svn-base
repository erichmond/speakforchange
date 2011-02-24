#!/usr/local/bin/ruby

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
 File: hangup.rb
 Created On: Mon Mar 30 10:04:46 EDT 2009
===============================================================================
=end

begin
	
	$logfile = File.join(File.dirname(__FILE__), "../log", "agi_hangup.log")
	$errlog = File.open($logfile, "a")
  $stderr = $errlog

	def log(msg)
		%x[echo "[#{Time.now}]#{msg}" >> #{$logfile}]
	end
	
	log("\nSTARTING HANGUP.RB AS DEADAGI")
	
	require "yaml"
  YML_FILE = File.join(File.dirname(__FILE__), "hangup.yml")
  CONFIG = YAML.load_file(YML_FILE)
	RAILS_ROOT=CONFIG[:RAILS_ROOT]
	
	log "CONFIG = #{CONFIG[:env]}"
	
	DB_CONFIG = YAML.load_file(File.join(RAILS_ROOT, "config", "database.yml"))[CONFIG[:env]]

	log "DB_CONFIG = #{DB_CONFIG.class}"

	require "rubygems"
	require "ruby-agi"
	
	agi = AGI.new
	agi.answer

	log "Handling Hangup Case for Call with UID=#{agi.uniqueid}"

	$:.unshift File.join(RAILS_ROOT, '/app/models/')
	$:.unshift File.dirname(__FILE__)
	
	log("Updated Ruby Lib Path = #{$:}")
	
	require 'json'
	require 'cgi'
	require 'ym4r/google_maps/geocoding'
	require 'net/http'
	include Ym4r::GoogleMaps
	
	
	
	require "active_support"
	require "active_record"	
	
	class Legislator < ActiveRecord::Base
    def shortname
      [title + '.', firstname, lastname + (name_suffix ? ', ' + name_suffix : '')].join(' ')
    end
	end
	class Senator < Legislator
	end
	class Representative < Legislator
	end
	
	class Issue < ActiveRecord::Base
	end
	
	require "delivery.rb"
	require "zipcode_geolocation.rb"
	require "message_for_hangup.rb"
	require "message_on_issue.rb"
	require "message_to_legislator.rb"
	
	
	# just pass in the config params unless we are using sqlite3 as the DB
	if (DB_CONFIG["adapter"] == "sqlite3")
		DB_CONFIG["database"] = File.join(RAILS_ROOT, DB_CONFIG["database"])
	end

	ActiveRecord::Base.establish_connection(DB_CONFIG)
	
	msg = Message.find_by_asterisk_uid(agi.uniqueid)
	
	if msg.nil?
		log "No message for call uid #{agi.uniqueid}. End handle Hangup."
	else
		log "Message(#{msg.id}) found and will deliver if #{msg.deliveries.empty?} == true"
		msg.package_and_deliver() if msg.deliveries.empty?
	end
	
	log "EXITING HANGUP.RB AS DEADAGI"
	log "-"
	
	agi.hangup
	
rescue Exception => e
	$errlog.write("EXCEPTION=#{e.message}:#{e.backtrace}")
	$errlog.write("\n-\n")
end
