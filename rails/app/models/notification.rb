class Notification < ActionMailer::Base
  
  def error_message(exception, trace, params, env, sent_on = Time.now)
    @recipients = ['eric@speakforchange.us', 'dan@speakforchange.us', 'carlos@speakforchange.us']
    @from = 'error@speakforchange.us'
    @subject = "Error message: #{env['REQUEST_URI']}"
    @sent_on = sent_on
    @body = {
      :exception => exception,
      :trace => trace,
      :params => params,
      :env => env
    }
  end

end
