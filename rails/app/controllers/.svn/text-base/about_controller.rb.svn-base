require 'rdiscount'

class AboutController < ApplicationController
  def index

markdown_string = <<EOF
## Mission Statement

Communicating with our representatives in Congress is critical for our democracy.
But there are two problems people face when they want do this.  First, most
people don't know offhand how to contact their representative.  And second,
there's no way for other concerned citizens to hear what you say to your
representative or to join in on the dialogue.

SpeakForChange takes on both of these problems.

SpeakForChange simplifies the process when you want to say something to
Congress. All you need is a phone and a zipcode. Just dial our toll free number
and follow the prompts to find your representative, and you'll be able to leave
her a voice message in no time.

SpeakForChange also opens up this conversation by posting your voice message
on our website for anyone to listen to and comment on. You can think of this as
a way of cc'ing the rest of America when you have something to say to Congress. 
It's a new kind of public forum. It's public voicemail for democracy.

Call and speak your mind today.  

## Screencast

<embed src="http://blip.tv/play/AfbOFAA" type="application/x-shockwave-flash" width="704" height="455" allowscriptaccess="always" allowfullscreen="true"></embed>

Screencast by [Dave Fisher](http://whatisnoise.com).

## Who We Are

[Carlos Lenz](http://twitter.com/3lsilver), [Daniel
Choi](http://twitter.com/danchoi), and [Eric
Richmond](http://twitter.com/stompyj) are three developers who live in the
Cambridge, MA area.  We believe in the power of an open and transparent
democracy.  SpeakForChange.us is our entry in the
[Apps For America](http://www.sunlightlabs.com/appsforamerica/ "Apps For America")
contest.

## Technology 

* Telephony provided by [Asterisk PBX](http://asterisk.org/ "Asterisk")  
* Telephony Development Framework provided by [Adhearsion](http://adhearsion.com "Adhearsion")  
* Legislator lookup by zipcode during the telephone call provided by the [Sunlight API](http://wiki.sunlightlabs.com/index.php/Sunlight_API_Documentation) from the [Sunlight Foundation](http://www.sunlightfoundation.com/) and the [Ruby Sunlight API Gem](http://luigimontanez.com/2009/ruby-sunlight-api-gem-0-9-released) by Luigi Montanez
* Web Framework provided by [Ruby on Rails](http://rubyonrails.org "Ruby on Rails")    
* Comments provided by [Disqus](http://disqus.com "Disqus")  
* Screencasting software by [Screenflow](http://www.telestream.net/screen-flow/overview.htm"Screenflow")
* Website hosting by [Linode](http://linode.com)


## FAQ

**So... is my voicemail going to actually be forwarded to the congresspeople
that I've selected?**  

The short answer is not yet. But we hope that as more people leave voice
messages and comments on SpeakForChange, our legislators in Congress will notice
and start visiting the site to listen to their constituents. We also
provide RSS feeds for messages by legislator, so they can get
realtime updates on what you, their constituents, are thinking. We are also
exploring ways of sending the voicemails directly to each legislators office.


**What license applies to the voicemails I post on SpeakForChange.us?**

Any content you post on this website falls under the [Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License](http://creativecommons.org/licenses/by-nc-sa/3.0/us/).
Click on the link to see the terms of this license.

**How do I add a title, a link, or tags to my message?**

Click on the "edit my message" link on the navigation bar and enter your zipcode and the message password you got at the end of your phone call. On the next screen you'll be able to add a title, a link, and tags to your message.


## Community Rules 

Please use language appropriate for a public forum and act in the spirit of
democratic citizenship. We won't play thought police, but we reserve the right
to remove messages that are gratuitously vulgar, racist, sexist, or offensive in
nature.
  
## What's next? 

This is just the beginning. We hope to add many more features to SpeakForChange
to make the site an ever more useful and powerful tool for democracy.

EOF
        
    @markdown = RDiscount.new(markdown_string).to_html
  end
end
