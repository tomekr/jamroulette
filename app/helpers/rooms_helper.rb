module RoomsHelper
  def jam_user(jam)
    jam.user ? jam.user.display_name : "Anonymous"
  end
end
