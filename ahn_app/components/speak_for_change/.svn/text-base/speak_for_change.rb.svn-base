# See http://docs.adhearsion.com for more information on how to write components or
# look at the examples in newly-created projects.

require "rubygems"
require "yaml"

require 'json'
require 'cgi'
require 'ym4r/google_maps/geocoding'
require 'net/http'
include Ym4r::GoogleMaps

require "legislator.rb"
require "message.rb"
require "message_to_legislator.rb"
require "message_on_issue.rb"

=begin
initialization do

	Events.register_callback("/asterisk/hungup_call") do |event|
		begin
			ahn_log.hungup.debug "HANDLING HUNGUP EVENT"
			
			call_uid = event.call.uniqueid
			ahn_log.hungup.debug "Call hungup... for uniqueid = #{call_uid}"
			msg = Message.find_by_asterisk_uid(call_uid)
			
			if msg.nil?
				ahn_log.hungup.debug "No message for call uid #{call_uid}. End handle Hangup."
			else
				ahn_log.hungup.debug "Message(#{msg.id}) found and will deliver if #{msg.deliveries.empty?} == true" 
				msg.package_and_deliver() if msg.deliveries.empty?
			end
			
		rescue => exp
			ahn_log.hungup.debug "Exception in hungup call back: #{exp.message}"
			exp.backtrace.each { |b|  ahn_log.hungup.debug b }
		end	
	end		
	
end
=end

methods_for :events do
	
	def handle_hangup(call_uid)
		ahn_log.handle_hangup.info "Attempting to Handle Hangup for call_uid #{call_uid}"
		
		msg = Message.find_by_asterisk_uid(call_uid)
		ahn_log.handle_hangup.info "No message for call uid #{call_uid}. End handle Hangup." and return if msg.nil?
		
		begin
			ahn_log.handle_hangup.error "Attempting to deliver message for #{call_uid}"
			msg.package_and_deliver
		rescue Exception => e
			ahn_log.handle_hangup.error "Exception #{e.message}"
		end
		
		ahn_log.handle_hangup.debug "End handle Hangup"

	end
	
end

methods_for :dialplan do
	def handle_hangup(call_uid)
		ahn_log.handle_hangup.info "Attempting to Handle Hangup"
		
		msg = Message.find_by_asterisk_uid(call_uid)
		ahn_log.handle_hangup.info "No message for call uid #{call_uid}. End handle Hangup." and return if msg.nil?
		
		begin
			ahn_log.handle_hangup.error "Attempting to deliver message for #{call_uid}"
			msg.package_and_deliver
		rescue Exception => e
			ahn_log.handle_hangup.error "Exception #{e.message}"
		end
		
		ahn_log.handle_hangup.debug "End handle Hangup"

	end
	
	def state_from_zip(zipcode)
		return Message.state_from_zip(zipcode)
	end
	
	def track_retries(counter, max)
		return counter = 0 if counter >= max
		return counter += 1
	end
	
	def retry?(counter, max)
		return (counter < max)
	end
	
  def get_msg_file_path()
		return SPEAKFORCHANGE_CONFIG[:messages_dir]
	end


	def zip_lookup(zipcode)
		return SunLit::Legislator.all_in_zipcode(zipcode)
	end
	
	# gets the file where the TTS prompt for picking a legislator has been recorded
	# as well as the legislators picked for the zip code
	def get_tts_for_legislators(zipcode, agi_uid)
		legislators = SunLit::Legislator.all_in_zipcode(zipcode)
		
		# TODO! change to handle this error not raise exception
		raise Exception.new("No Legislators Found for #{zipcode}") if legislators.nil?
		
		tts_text = ""
		
		index = 1
		legislators.each { |member|  

			title = (member.title == "Sen") ? "Senator" : "Representative"

			tts_text += "For #{title} #{member.firstname} #{member.lastname} press #{index}. "
			index += 1
		}
		
		tts_text += "To send a message to everyone. Press #{index}."
		
		file = "/tmp/pick_rep_prompt_for_#{agi_uid}"
		
		SpeakChangeHelper.generate_tts_file(tts_text, file)
		

		return legislators, file
	end
	
	
	def new_message_from_selection(selection, legislators, file_path, zipcode, call_uid)
		

		
		# index of selection made by the user - convert to int b/c expecting string
		index = selection.to_i - 1
		selected_lgs = SpeakChangeHelper.get_selected_legislators(legislators, index)
		# since all legislators are from the same state then grabbing state from first legislator
		msg = MessageToLegislator.create(	:zipcode=>zipcode,
																			:file=>file_path,
																			:asterisk_uid=>call_uid,
																			:state=>selected_lgs[0].state,
																			:messageable_ids=>selected_lgs.collect { |l| l.id })
														
		ahn_log "Created new message in db with id(#{msg.id})"										

		return msg	
	end
		
end


# Sunlight Gem Code Copied Here B/C of issues with loading it in AHN environment

module SunLit
	class SunlightBase

	  API_URL = "http://services.sunlightlabs.com/api/"
	  API_FORMAT = "json"
	  @@api_key = ''
  
	  def self.api_key
	   @@api_key
	  end

	  def self.api_key=(key)
	   @@api_key = key
	  end

	  # Constructs a Sunlight API-friendly URL
	  def self.construct_url(api_method, params)
	    if api_key == nil or api_key == ''
	      raise "Failed to provide Sunlight API Key"
	    else
	      "#{API_URL}#{api_method}.#{API_FORMAT}?apikey=#{api_key}#{hash2get(params)}"
	    end
	  end

	  # Converts a hash to a GET string
	  def self.hash2get(h)

	    get_string = ""

	    h.each_pair do |key, value|
	      get_string += "&#{key.to_s}=#{CGI::escape(value.to_s)}"
	    end

	    get_string

	  end # def hash2get    

	  # Use the Net::HTTP and JSON libraries to make the API call
	  #
	  # Usage:
	  #   Legislator::District.get_json_data("http://someurl.com")    # returns Hash of data or nil
	  def self.get_json_data(url)

	    response = Net::HTTP.get_response(URI.parse(url))
	    if response.class == Net::HTTPOK
	      result = JSON.parse(response.body)
	    else
	      nil
	    end

	  end # self.get_json_data

	end # class Base

	class District < SunlightBase

	  attr_accessor :state, :number

	  def initialize(state, number)
	    @state = state
	    @number = number
	  end


	  # Usage:
	  #   Sunlight::District.get(:latitude => 33.876145, :longitude => -84.453789)    # returns one District object or nil
	  #   Sunlight::District.get(:address => "123 Fifth Ave New York, NY")     # returns one District object or nil
	  #
	  def self.get(params)

	    if (params[:latitude] and params[:longitude])

	      get_from_lat_long(params[:latitude], params[:longitude])

	    elsif (params[:address])

	      # get the lat/long from Google
	      placemarks = Geocoding::get(params[:address])

	      unless placemarks.empty?
	        placemark = placemarks[0]
	        get_from_lat_long(placemark.latitude, placemark.longitude)
	      end

	    else
	      nil # appropriate params not found
	    end

	  end



	  # Usage:
	  #   Sunlight::District.get_from_lat_long(-123, 123)   # returns District object or nil
	  #
	  def self.get_from_lat_long(latitude, longitude)

	    url = construct_url("districts.getDistrictFromLatLong", {:latitude => latitude, :longitude => longitude})

	    if (result = get_json_data(url))

	      districts = []
	      result["response"]["districts"].each do |district|
	        districts << District.new(district["district"]["state"], district["district"]["number"])
	      end

	      districts.first

	    else  
	      nil
	    end # if response.class

	  end



	  # Usage:
	  #   Sunlight::District.all_from_zipcode(90210)    # returns array of District objects
	  #
	  def self.all_from_zipcode(zipcode)

	    url = construct_url("districts.getDistrictsFromZip", {:zip => zipcode})

	    if (result = get_json_data(url))

	      districts = []
	      result["response"]["districts"].each do |district|
	        districts << District.new(district["district"]["state"], district["district"]["number"])
	      end

	      districts

	    else  
	      nil
	    end # if response.class

	  end



	  # Usage:
	  #   Sunlight::District.zipcodes_in("NY", 29)     # returns ["14009", "14024", "14029", ...]
	  #
	  def self.zipcodes_in(state, number)

	    url = construct_url("districts.getZipsFromDistrict", {:state => state, :district => number})

	    if (result = get_json_data(url))
	      result["response"]["zips"]
	    else  
	      nil
	    end # if response.class

	  end



	end # class District

	class Filing < SunlightBase
	  attr_accessor :filing_id, :filing_period, :filing_date, :filing_amount,
	                :filing_year, :filing_type, :filing_pdf, :client_senate_id,
	                :client_name, :client_country, :client_state,
	                :client_ppb_country, :client_ppb_state, :client_description,
	                :client_contact_firstname, :client_contact_middlename,
	                :client_contact_lastname, :client_contact_suffix,
	                :registrant_senate_id, :registrant_name, :registrant_address,
	                :registrant_description, :registrant_country,
	                :registrant_ppb_country, :lobbyists, :issues

	  # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
	  #
	  def initialize(params)
	    params.each do |key, value|    
	      instance_variable_set("@#{key}", value) if Filing.instance_methods.include? key
	    end
	  end

	  #
	  # Get a filing based on filing ID.
	  #
	  # See the API documentation:
	  #
	  # http://wiki.sunlightlabs.com/index.php/Lobbyists.getFiling
	  #
	  # Returns:
	  #
	  # A Filing and corresponding Lobbyists and Issues matching
	  # the given ID, or nil if one wasn't found.
	  #
	  # Usage:
	  #
	  #   filing = Sunlight::Filing.get("29D4D19E-CB7D-46D2-99F0-27FF15901A4C")
	  #   filing.issues.each { |issue| ... }
	  #   filing.lobbyists.each { |lobbyist| ... }
	  #
	  def self.get(id)
	    url = construct_url("lobbyists.getFiling", :id => id)

	    if (response = get_json_data(url))
	      if (f = response["response"]["filing"])
	        filing = Filing.new(f)
	        filing.lobbyists = filing.lobbyists.map do |lobbyist|
	          Lobbyist.new(lobbyist["lobbyist"])
	        end
	        filing.issues = filing.issues.map do |issue|
	          Issue.new(issue["issue"])
	        end
	        filing
	      else
	        nil
	      end
	    else
	      nil
	    end
	  end

	  #
	  # Search the filing database. At least one of client_name or
	  # registrant_name must be provided, along with an optional year.
	  # Note that year is recommended, as the full data set dating back
	  # to 1999 may be enormous.
	  #
	  # See the API documentation:
	  #
	  # http://wiki.sunlightlabs.com/index.php/Lobbyists.getFilingList
	  #
	  # Returns:
	  #
	  # An array of Filing objects that match the conditions
	  #
	  # Usage:
	  #
	  #   filings = Filing.all_where(:client_name => "SUNLIGHT FOUNDATION")
	  #   filings.each do |filing|
	  #     ...
	  #     filing.issues.each { |issue| ... }
	  #     filing.lobbyists.each { |issue| ... }    
	  #   end
	  #
	  def self.all_where(params)
	    if params[:client_name].nil? and params[:registrant_name].nil?
	      nil
	    else
	      url = construct_url("lobbyists.getFilingList", params)
      
	      if (response = get_json_data(url))
	        filings = []
        
	        response["response"]["filings"].each do |result|
	          filing = Filing.new(result["filing"])

	          filing.lobbyists = filing.lobbyists.map do |lobbyist|
	            Lobbyist.new(lobbyist["lobbyist"])
	          end
	          filing.issues = filing.issues.map do |issue|
	            Issue.new(issue["issue"])
	          end

	          filings << filing
	        end
        
	        if filings.empty?
	          nil
	        else
	          filings
	        end
	      else
	        nil
	      end
	    end # if params
	  end # def self.all_where
  
	end # class Filing

	class Issue < SunlightBase
	  attr_accessor :code, :specific_issue

	  # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
	  #
	  def initialize(params)
	    params.each do |key, value|    
	      instance_variable_set("@#{key}", value) if Issue.instance_methods.include? key
	    end
	  end
	end

	class Legislator < SunlightBase


	  attr_accessor :title, :firstname, :middlename, :lastname, :name_suffix, :nickname,
	                :party, :state, :district, :gender, :phone, :fax, :website, :webform,
	                :email, :congress_office, :bioguide_id, :votesmart_id, :fec_id,
	                :govtrack_id, :crp_id, :event_id, :congresspedia_url, :youtube_url,
	                :twitter_id, :fuzzy_score, :in_office, :senate_class

		FIELDS_TO_COPY = [:title, :firstname, :middlename, :lastname, :name_suffix, :nickname,
								                :party, :state, :district, :gender, :phone, :fax, :website, :webform,
								                :email, :congress_office, :bioguide_id, :votesmart_id, :fec_id,
								                :govtrack_id, :crp_id, :event_id, :congresspedia_url, :youtube_url,
								                :twitter_id, :fuzzy_score, :in_office, :senate_class]

	  # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
	  #
	  def initialize(params)
	    params.each do |key, value|    
	      instance_variable_set("@#{key}", value) if Legislator.instance_methods.include? key
	    end
	  end
	
		def is_rep?
			return self.title == "Rep"
		end
	
		def is_senator?
			return self.title == "Sen"
		end

	  #
	  # Useful for getting the exact Legislators for a given district.
	  #
	  # Returns:
	  #
	  # A Hash of the three Members of Congress for a given District: Two
	  # Senators and one Representative.
	  #
	  # You can pass in lat/long or address. The district will be
	  # determined for you:
	  #
	  #   officials = Legislator.all_for(:latitude => 33.876145, :longitude => -84.453789)
	  #   senior = officials[:senior_senator]
	  #   junior = officials[:junior_senator]
	  #   rep = officials[:representative]
	  #
	  #   Sunlight::Legislator.all_for(:address => "123 Fifth Ave New York, NY 10003")
	  #   Sunlight::Legislator.all_for(:address => "90210") # it'll work, but use all_in_zip instead
	  #
	  def self.all_for(params)

	    if (params[:latitude] and params[:longitude])
	      Legislator.all_in_district(District.get(:latitude => params[:latitude], :longitude => params[:longitude]))
	    elsif (params[:address])
	      Legislator.all_in_district(District.get(:address => params[:address]))
	    else
	      nil # appropriate params not found
	    end

	  end


	  #
	  # A helper method for all_for. Use that instead, unless you 
	  # already have the district object, then use this.
	  #
	  # Usage:
	  #
	  #   officials = Sunlight::Legislator.all_in_district(District.new("NJ", "7"))
	  #
	  def self.all_in_district(district)

	    senior_senator = Legislator.all_where(:state => district.state, :district => "Senior Seat").first
	    junior_senator = Legislator.all_where(:state => district.state, :district => "Junior Seat").first
	    representative = Legislator.all_where(:state => district.state, :district => district.number).first

	    {:senior_senator => senior_senator, :junior_senator => junior_senator, :representative => representative}

	  end


	  #
	  # A more general, open-ended search on Legislators than #all_for.
	  # See the Sunlight API for list of conditions and values:
	  #
	  # http://services.sunlightlabs.com/api/docs/legislators/
	  #
	  # Returns:
	  #
	  # An array of Legislator objects that matches the conditions
	  #
	  # Usage:
	  #
	  #   johns = Sunlight::Legislator.all_where(:firstname => "John")
	  #   floridians = Sunlight::Legislator.all_where(:state => "FL")
	  #   dudes = Sunlight::Legislator.all_where(:gender => "M")
	  #
	  def self.all_where(params)

	    url = construct_url("legislators.getList", params)

	    if (result = get_json_data(url))

	      legislators = []
	      result["response"]["legislators"].each do |legislator|
	        legislators << Legislator.new(legislator["legislator"])
	      end

	      legislators

	    else  
	      nil
	    end # if response.class

	  end
  
	  #
	  # When you only have a zipcode (and could not get address from the user), use this.
	  # It specifically accounts for the case where more than one Representative's district
	  # is in a zip code.
	  # 
	  # If possible, ask for full address for proper geocoding via Legislator#all_for, which
	  # gives you a nice hash.
	  #
	  # Returns:
	  #
	  # An array of Legislator objects
	  #
	  # Usage:
	  #
	  #   legislators = Sunlight::Legislator.all_in_zipcode(90210)
	  #
	  def self.all_in_zipcode(zipcode)

	    url = construct_url("legislators.allForZip", {:zip => zipcode})
    
	    if (result = get_json_data(url))

	      legislators = []
	      result["response"]["legislators"].each do |legislator|
	        legislators << Legislator.new(legislator["legislator"])
	      end

	      legislators

	    else  
	      nil
	    end # if response.class

	  end # def self.all_in_zipcode
  
  
	  # 
	  # Fuzzy name searching. Returns possible matching Legislators 
	  # along with a confidence score. Confidence scores below 0.8
	  # mean the Legislator should not be used.
	  #
	  # The API documentation explains it best:
	  # 
	  # http://wiki.sunlightlabs.com/index.php/Legislators.search
	  #
	  # Returns:
	  #
	  # An array of Legislators, with the fuzzy_score set as an attribute
	  #
	  # Usage:
	  #
	  #   legislators = Sunlight::Legislator.search_by_name("Teddy Kennedey")
	  #   legislators = Sunlight::Legislator.search_by_name("Johnny Kerry", 0.9)
	  #
	  def self.search_by_name(name, threshold='0.8')
    
	    url = construct_url("legislators.search", {:name => name, :threshold => threshold})
    
	    if (response = get_json_data(url))
      
	      legislators = []
	      response["response"]["results"].each do |result|
	        if result
	          legislator = Legislator.new(result["result"]["legislator"])
	          fuzzy_score = result["result"]["score"]
          
	          if threshold.to_f < fuzzy_score.to_f
	            legislator.fuzzy_score = fuzzy_score.to_f
	            legislators << legislator
	          end
	        end
	      end
      
	      if legislators.empty?
	        nil
	      else
	        legislators 
	      end
      
	    else
	      nil
	    end
    
	  end # def self.search_by_name
  
	end # class Legislator

	class Lobbyist < SunlightBase
	  attr_accessor :firstname, :middlename, :lastname, :suffix,
	                :official_position, :filings, :fuzzy_score

	  # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
	  #
	  def initialize(params)
	    params.each do |key, value|    
	      instance_variable_set("@#{key}", value) if Lobbyist.instance_methods.include? key
	    end
	  end

	  #
	  # Fuzzy name searching of lobbyists. Returns possible matching Lobbyists
	  # along with a confidence score. Confidence scores below 0.8
	  # mean the lobbyist should not be used.
	  #
	  # See the API documentation:
	  #
	  # http://wiki.sunlightlabs.com/index.php/Lobbyists.search
	  #
	  # Returns:
	  #
	  # An array of Lobbyists, with the fuzzy_score set as an attribute
	  #
	  # Usage:
	  #
	  #   lobbyists = Lobbyist.search("Nisha Thompsen")
	  #   lobbyists = Lobbyist.search("Michael Klein", 0.95, 2007)
	  #
	  def self.search_by_name(name, threshold=0.9, year=Time.now.year)

	    url = construct_url("lobbyists.search", :name => name, :threshold => threshold, :year => year)
   
	    if (results = get_json_data(url))
	      lobbyists = []
	      results["response"]["results"].each do |result|
	        if result
	          lobbyist = Lobbyist.new(result["result"]["lobbyist"])
	          fuzzy_score = result["result"]["score"]

	          if threshold.to_f < fuzzy_score.to_f
	            lobbyist.fuzzy_score = fuzzy_score.to_f
	            lobbyists << lobbyist
	          end
	        end
	      end

	      if lobbyists.empty?
	        nil
	      else
	        lobbyists
	      end
   
	    else
	      nil
	    end
	  end # def self.search
	end # class Lobbyist
end

SunLit::SunlightBase.api_key = SPEAKFORCHANGE_CONFIG[:sunlight_api_key]


class SpeakChangeHelper
	
	# this method will return an array of active record Legislator models
	# which correspond with the SLegislator object returned by the Sunlight API.
	# this method will create the a new record in DB if it does not exist
	# searches are conducted by the votemsart_id
	def self.get_selected_legislators(legislators, index)
		
		lgs_from_db = Array.new
		
		# get all legislators from the db
		# if all were chosen
		if index == legislators.length
			legislators.each { |l|  
				lgs = Legislator.find_by_votesmart_id(l.votesmart_id)
				if lgs.nil?
					lgs = Legislator.new()
					SunLit::Legislator::FIELDS_TO_COPY.each { |field| lgs.send("#{field}=", l.send("#{field}")) }
					lgs.save!
				end
				
				lgs_from_db << lgs
			}
			return lgs_from_db
			
		end
		
		# selected just 1 legislator
		ahn_log "HELLO! ABOUT TO ACCESS Legislator - #{Legislator.superclass}"
		lgs = Legislator.find_by_votesmart_id(legislators[index].votesmart_id)
		
		if lgs.nil?
			lgs = Legislator.new()
			SunLit::Legislator::FIELDS_TO_COPY.each { |field|  lgs.send("#{field}=", legislators[index].send("#{field}")) }
			lgs.save!
		end
		
		lgs_from_db << lgs
		
		return lgs_from_db
	end
	
	def self.generate_tts_file(tts_text, file)
		
		case TTS_ENGINE
			when :flite
				SpeakChangeHelper.tts_flite(tts_text, file)
			when :say
				SpeakChangeHelper.tts_say(tts_text, file)
		end
		
		ahn_log.debug "TTS prompt is in file: #{file}"
		
	end
	
	private
	def self.tts_flite(text, file)
		result = %x[/usr/bin/flite "#{text}" -o #{file}.wav]
		
		# TODO! figure out how to parse the result for errors, I think if there is no result text
		# then there are no errors.  Must be confirmed
		ahn_log.debug "Flite result is: #{result}"
		
	end
	
	def self.tts_say(text, file)
		result = %x[/usr/bin/say -o #{file}.aiff "#{text}" ]
		result += %x[sox #{file}.aiff -r 8000 #{file}.wav]
		result += %x[rm #{file}.aiff]
		
		# TODO! figure out how to parse the result for errors, I think if there is no result text
		# then there are no errors.  Must be confirmed
		ahn_log.debug "OS X result is: #{result}"

	end
	
end


