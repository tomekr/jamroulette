if ENV['STAGING']
  ActionMailer::Base.register_interceptor(StagingEmailInterceptor)
end
