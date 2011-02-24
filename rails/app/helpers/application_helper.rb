# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def playlist(messages)
    content_tag :ul, :class => "playlist" do
      render_as_string messages.map {|m| message_player(m)}.join
    end
  end

  def message_player(message)
    content_tag :li do
      message_images(message) +
      message_audio_title(message) + "<br/>" + 
      link_to( "Play message", "/messages/#{message.file}", :class => "audio"  )  + " " +
      link_to( "Comment", ""  ) 

    end
  end

  def message_images(message)
    if message.is_a?(MessageToLegislator)
      message.deliveries.map {|y| y.messageable}.map do |x|
        image_for x
      end.join
    elsif message.issue
      image_tag message.issue.image
    else
      image_tag "capitol2.jpg"
    end
  end

  def image_for(x)
    link_to( image_tag(x.image), x )
  end

  # for expiration and available from dates
  def format_date(date)
    return unless date
    if date.year == Time.now.year
      date.to_date.strftime("%b %e")
    else
      format_date_with_yr(date)
    end
  end
end
