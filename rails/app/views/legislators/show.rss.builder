xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @legislator.fullname
    xml.link @rss_url 
    xml.description "Listing of the most recent messages for #{@legislator.fullname}"
    xml.language "en-US"
    xml.lastBuildDate DateTime.now.to_s(:rfc822)
    for message in @legislator.messages
      xml.item do
        xml.title message.title_for_rss
        xml.description message.description_for_rss
        xml.enclosure (:url => "#{get_current_hostname}#{message.mp3_audio_path}", :type => "audio/mpeg")
        xml.pubDate message.created_at.to_s(:rfc822)
        xml.link message_url(message)
      end
    end
  end
end
