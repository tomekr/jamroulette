class StagingEmailInterceptor
  def self.delivering_email(mail)
    mail.subject.prepend('[STAGING] ')
  end
end
