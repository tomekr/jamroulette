class JamMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def jam_uploaded_email(jam)
    @jam = jam
    @uploader = jam.user.display_name
    @room_name = jam.room.name
    @room_owner = jam.room.user.display_name
    @filename = jam.file.filename
    mail(to: jam.room.user.email, subject: "#{@uploader} uploaded a jam to #{@room_name}")
  end

  def jam_uploaded_contributor_email(jam, contributor)
    @jam = jam
    @uploader = jam.user.display_name
    @room_name = jam.room.name
    @filename = jam.file.filename
    @contributor = contributor.display_name

    mail(to: contributor.email, subject: "#{@uploader} uploaded a jam to a room you've contributed to!")
  end
end
