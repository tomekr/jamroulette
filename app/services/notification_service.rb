class NotificationService
  def self.notify(subject:, user:, event:)
    notification = subject.notifications.create!(
      user: user,
      event: event,
    )
  end
end
