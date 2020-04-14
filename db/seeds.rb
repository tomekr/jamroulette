# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

bob = User.create(
  display_name: 'bobby',
  email: 'bob@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now
)

alice = User.create(
  display_name: 'alice',
  email: 'alice@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now
)

# Create an empty room
empty_room = Room.create!(public_id: 'empty', user: bob, name: 'Empty Room')

# Create a room with two attached jams
room = Room.create!(public_id: 'jams', user: bob, name: 'Bob Jam Room')

jam = room.jams.build(
  bpm_list: '120',
  jam_type_list: ['Mix'],
  could_use_list: %w[Bass Vocals],
  duration_list: ['90'],
  promoted_at: Time.current,
  user: bob
)
jam.file.attach(io: File.open('spec/support/assets/test.mp3'), filename: 'test.mp3', content_type: 'audio/mpeg')
jam.save

other_jam = room.jams.build(
  bpm_list: '120',
  jam_type_list: ['Mix'],
  could_use_list: %w[Vocals Synth],
  duration_list: ['125'],
  promoted_at: Time.current,
  user: alice
)
other_jam.file.attach(io: File.open('spec/support/assets/test.mp3'), filename: 'test.mp3', content_type: 'audio/mpeg')
other_jam.save

alice_room = Room.create!(public_id: 'alice-jams', user: alice, name: 'Alice Jam Room')

alice_jam = alice_room.jams.build(
  bpm_list: '120',
  jam_type_list: ['Mix'],
  could_use_list: %w[Vocals Guitar],
  duration_list: ['130'],
  promoted_at: Time.current,
  user: alice
)
alice_jam.file.attach(io: File.open('spec/support/assets/test.mp3'), filename: 'test.mp3', content_type: 'audio/mpeg')
alice_jam.save

# TODO: Remove when no longer in beta
InviteCode.create(code: 'Mellon')
