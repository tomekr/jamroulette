class NotificationService
  def self.notify_on_jam_creation(jam, uploader)
    room = jam.room

    room.users.uniq.reject { |user| user == uploader }.each do |user|
      NotificationService.notify(
        subject: jam,
        user: user,
        event: :jam_created
      )
    end
  end

  def self.notify(subject:, user:, event:)
    notification = subject.notifications.create!(
      user: user,
      event: event
    )
  end
end
