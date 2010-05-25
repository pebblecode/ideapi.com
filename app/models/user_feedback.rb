class UserFeedback < ActionMailer::Base
  
  def feedback(feedback, sent_at = Time.now)
    @subject = 'Feedback from user'
    @body[:feedback] = feedback
    #@recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
    @recipients = 'support@ideapi.net'
    @from = 'alex@abutcher.co.uk'
    @sent_on = sent_at
  end

end
