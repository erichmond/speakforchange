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
 File: dialplan.rb
 Created On: Thu Mar 26 11:13:03 EDT 2009
===============================================================================
=end

sip {
	+speakchange
}


speakchange {

	answer
	
	ahn_log.debug "RAILS_ROOT=#{RAILS_ROOT} for env=#{RAILS_ENV}"	
	
	@call_uid = call.variables[:uniqueid] 
	ahn_log "UNIQUEID passed is #{@call_uid}"
	
	@exten = call.variables[:extension]
	
	ahn_log "Extension is #{@exten}"


	@timeout_retry = 0
	play 'silence/2' 
	+extension_input

}




close{
	play 'speakchange/good_bye'
	hangup
}

extension_input {
	max_retry = 2
	@timeout_retry = track_retries(@timeout_retry, max_retry)
	user_input = input :play=>"speakchange/welcome_prompt", :timeout => 5.seconds
	
	ahn_log.debug "User Input =[#{user_input}] length == [#{user_input.length}]"
		
	if user_input.length == 3
		@legislator_ext = user_input
		+direct_to_legislator
	end

	if user_input.length == 4
		@issue_ext = user_input
		+by_issue
	end

	if user_input.length >= 5
		@zipcode = user_input 
		+zipcode_validate
	end
	
	play "speakchange/invalid" and +extension_input if retry?(@timeout_retry, max_retry)
	
	+close

}

zipcode_validate {
	ahn_log.debug "In zipcode_validate"
	
	if @zipcode.length < 5
		@timeout_retry = 0
		play "speakchange/invalid_zipcode"
		+zipcode_enter 
	end

	@state = state_from_zip(@zipcode)
	ahn_log.debug "State from #{@zipcode} is #{@state}"

	# valid zipcode?
	if @state.nil?
		play "speakchange/invalid_zipcode"
		@timeout_retry = 0
		+zipcode_enter
	end
		
	# all good so lets go on
	+zipcode_review
}

zipcode_enter {
	max_retry = 3
	ahn_log.debug("timeout retry = #{@timeout_retry}")
	@timeout_retry = track_retries(@timeout_retry, max_retry)
	ahn_log.debug("timeout retry = #{@timeout_retry}")
	
	@zipcode = input :play => "speakchange/enter_zipcode_prompt", :timeout => 8.seconds
	
	if @zipcode.length >= 5
		@state = state_from_zip(@zipcode)
		ahn_log.debug "State from #{@zipcode} is #{@state}"
		# valid zipcode?
		play "speakchange/invalid_zipcode" and +zipcode_enter if @state.nil?
		# all good so lets go on
		+zipcode_review 
	end
	
	play "speakchange/invalid" and +zipcode_enter if retry?(@timeout_retry, max_retry)
	
	+close
	
}

zipcode_review {
	
	play "speakchange/zip_code_entered"
	say_digits(@zipcode)
	
	menu "speakchange/generic_selection_review", :timeout => 8.seconds, :tries => 3 do |link|
		link.list_legislators			1
		link.zipcode_enter				2
		
		link.on_invalid do
			ahn_log.debug "zipcode_review = on_invalid"
			play 'speakchange/invalid'
			
		end
    
		link.on_premature_timeout do
			ahn_log.debug "zipcode_review = on_premature_timeout"
			play 'speakchange/invalid'
		end
		
		link.on_failure do
			ahn_log.debug "zipcode_review = on_failure"
			+close
		end
	end

}


by_issue {
	ahn_log.debug "processing issue extension"
	@msg_type ="by_issue"
	
	@issue = Issue.find_by_extension(@issue_ext)
	
	# check for a nil issue
	if @issue.nil?
		ahn_log.error "The issue extension #{@issue_ext} is not valid."
		play 'speakchange/invalid'
		+close
	end
	
	play "speakchange/found_issue_prompt"
	
	@timeout_retry = 0
	+locate_by_zip
	
}

locate_by_zip {
	
	max_retry = 3
	ahn_log.debug("timeout retry = #{@timeout_retry}")
	@timeout_retry = track_retries(@timeout_retry, max_retry)
	ahn_log.debug("timeout retry = #{@timeout_retry}")
	
	@zipcode = input :play => "speakchange/enter_zipcode_prompt", :timeout => 8.seconds
	
	@state = state_from_zip(@zipcode)
	
	# check for a bad zip
	if @state.nil?
		play "speakchange/invalid_zipcode" and +locate_by_zip if retry?(@timeout_retry, max_retry)
		+close
	end
	
	+locate_by_zip_review
	
}

locate_by_zip_review {

	play "speakchange/zip_code_entered"
	say_digits(@zipcode)

	menu "speakchange/generic_selection_review", :timeout => 5.seconds, :tries => 3 do |link|
		link.record_message			1
		link.locate_by_zip			2

		link.on_invalid do
			ahn_log.debug "locate_by_zip_review = on_invalid"
			play 'speakchange/invalid'

		end

		link.on_premature_timeout do
			ahn_log.debug "locate_by_zip_review = on_premature_timeout"
			play 'speakchange/invalid'
		end

		link.on_failure do
			ahn_log.debug "locate_by_zip_review = on_failure"
			+close
		end
	end

}


direct_to_legislator{
	ahn_log "direct_to_legislator"
	
	@msg_type = "direct_to_legislator"
	
	@legislator_direct = Legislator.find_by_extension(@legislator_ext)
	
	if @legislator_direct.nil?
		play 'speakchange/invalid'
		+close
	end
	
	play "speakchange/found_legislator_prompt"
	
	+locate_by_zip
	
}

list_legislators {

	ahn_log "list_legislators"
	
	@msg_type = "by_zipcode"

	@legislators, tts_file = get_tts_for_legislators(@zipcode, @call_uid)
	
	play "speakchange/leave_message_for"
	
	upper_range = @legislators.length+1

	menu tts_file, :timeout => 8.seconds, :tries => 3 do |link|
		link.record_message_by_zipcode		1..upper_range
		
		link.on_invalid { play 'speakchange/invalid' }
		
		link.on_premature_timeout do |str|
			play 'speakchange/invalid'
		end

		link.on_failure do
			+close
		end
		
	end
}

record_message_by_zipcode{
	ahn_log "record_message_by_zipcode"
	@selection = extension
	+record_message
}

record_message{

	ahn_log "The user selected #{@msg_type}"
	
	message_path = "#{RAILS_ROOT}/public/messages/"
	msg_file_name = "message_id_#{@call_uid}"
	@message_file = message_path + msg_file_name
	ahn_log "Message file #{@message_file}"
	message_file_full_path = "#{@message_file}.wav"
	

	@message = nil
	if (@msg_type == "by_zipcode")
		@message = new_message_from_selection(@selection, @legislators, msg_file_name, @zipcode, @call_uid)	
		play "speakchange/record_message"
	elsif(@msg_type == "direct_to_legislator")
	
		@message = MessageToLegislator.create!(	:asterisk_uid => @call_uid, 
																						:file => msg_file_name,
																						:messageable_ids => [@legislator_direct.id],
																						:state => @state,
																						:zipcode=>@zipcode
																						)
		play "speakchange/record_prompt_only"																																								
	elsif(@msg_type == "by_issue")
		@message = MessageOnIssue.create!	(	:asterisk_uid => @call_uid, 
																				:file => msg_file_name, 
																				:messageable_ids => [@issue.id], 
																				:state=>@state, 
																				:zipcode=>@zipcode
																			)
		play "speakchange/record_prompt_only"
	else
		play "speakchange/invalid"
		ahn_log.error "TYPE=[#{msg_type}] was unrecognized!  MAJOR ERROR"
		+close
	end	
	
	
	ahn_log "File path to record #{message_file_full_path}"	
	record message_file_full_path
	
	+message_review
}

message_review {
	

	menu "speakchange/message_review", :timeout => 8.seconds, :tries => 3 do |link|
		link.accept_message						1
		link.listen_to_message 				2
		link.record_message_again			3
		link.cancel_message						4
		
		link.on_invalid { play 'speakchange/invalid' }
		
		link.on_premature_timeout { play 'speakchange/invalid' }
		
		link.on_failure { +close } 
		
	end
}

record_message_again {
	
	play "speakchange/record_prompt_only"
	
	message_file_full_path = "#{@message_file}.wav"
	
	ahn_log "File path for message to record again: #{message_file_full_path}"	
	record message_file_full_path
	+message_review
}

cancel_message {
	ahn_log.debug "cancel_message :: Message(#{@message.id}) will be destroyed"
	@message.destroy
	+close
}


accept_message {
	@message.package_and_deliver	
	
	play "speakchange/accept_prompt"
	
	+password_review
}

password_review {
	ahn_log.debug "password review for pass=#{@message.password.downcase}"
	
	play "speakchange/password_review"
	
	@message.password.downcase.each_char{|c|
	
		play("letters/#{c}") if c =~ /[a-z]/
		play("digits/#{c}") if c =~ /[0-9]/
		execute("wait","1")
	}
	
	
	menu "speakchange/password_repeat", :timeout => 5.seconds, :tries => 2 do |link|
		link.password_review	1
	end
	
	+close
	
}


listen_to_message {

	play @message_file
	
	+message_review
	
}


