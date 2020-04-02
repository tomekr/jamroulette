class NotificationService
  def self.notify(subject:, user:, event:)
    notification = subject.notifications.create!(
      user: user,
      notify_type: event,
      actor: subject.user
    )
  end
end
