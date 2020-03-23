# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

room = Room.create
room.room_hash = 'jam'
room.save

jam = room.jams.build(bpm: '120')
jam.file.attach(io: File.open('spec/support/assets/test.mp3'), filename: 'test.mp3')
jam.save

other_jam = room.jams.build(bpm: '120')
other_jam.file.attach(io: File.open('spec/support/assets/test.mp3'), filename: 'test.mp3')
other_jam.save

room_without_jam = Room.create
room_without_jam.room_hash = 'nojam'
room_without_jam.save
