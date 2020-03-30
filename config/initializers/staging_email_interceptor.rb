if ENV['STAGING']
  class StagingEmailInterceptor
    def self.delivering_email(mail)
      mail.subject.prepend('[STAGING] ')
    end
  end

  ActionMailer::Base.register_interceptor(StagingEmailInterceptor)
end
