# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts '###################### Add teams ######################'
filename = ->(team_name) { "#{team_name.downcase.gsub(' ', '_')}_logo.png" }
get_file = ->(team_name) { File.open(Rails.root.join('app/assets/images', filename.(team_name))) }
teams = [
  'Abb', 'Aludyne', 'Aqua', 'Bezalin', 'Dolina Skrzycznego',
  'Helios', 'Hutchinson', 'Marion', 'Nemak', 'Pre Zero', 'Selleo', 'Strumet'
].inject({}) do |hash, team_name|
  team = Team.create(name: team_name)
  file = get_file.(team_name)
  team.logo.attach(io: file, filename: filename.(team_name))

  hash[team_name] = team.id
  hash
end

puts '###################### Add users ######################'
user1 = User.create(email: 'u1@example.com', password: 'password', first_name: 'Irek', last_name: 'Swirek')
user2 = User.create(email: 'u2@example.com', password: 'password', first_name: 'Blazej', last_name: 'Karzel')
user3 = User.create(email: 'u3@example.com', password: 'password', first_name: 'Wojtek', last_name: 'Kortek')
user4 = User.create(email: 'u4@example.com', password: 'password', first_name: 'Marek', last_name: 'Lalek')
user5 = User.create(email: 'u5@example.com', password: 'password', first_name: 'Mateusz', last_name: 'Patroneusz')
user6 = User.create(email: 'admin@example.com', first_name: 'Mateusz', last_name: 'Admin', password: 'password', is_admin: true)

puts '###################### Add rounds ######################'
round1 = Round.create(number: 1, year: 2023)
round2 = Round.create(number: 2, year: 2023)

puts '###################### Add matches ######################'
match1 = Match.create(round_id: round1.id, match_date: Date.new(2023, 11, 9), home_team_id: teams['Dolina Skrzycznego'], away_team_id: teams['Bezalin'], home_team_score: 5, away_team_score: 1)
match2 = Match.create(round_id: round1.id, match_date: Date.new(2023, 11, 9), home_team_id: teams['Aludyne'], away_team_id: teams['Selleo'], home_team_score: 2, away_team_score: 2)
match3 = Match.create(round_id: round1.id, match_date: Date.new(2023, 11, 9), home_team_id: teams['Aqua'], away_team_id: teams['Abb'], home_team_score: 3, away_team_score: 4)
match4 = Match.create(round_id: round1.id, match_date: Date.new(2023, 11, 9), home_team_id: teams['Nemak'], away_team_id: teams['Helios'], home_team_score: 2, away_team_score: 10)
match5 = Match.create(round_id: round1.id, match_date: Date.new(2023, 11, 9), home_team_id: teams['Strumet'], away_team_id: teams['Hutchinson'], home_team_score: 1, away_team_score: 2)

match6 = Match.create(round_id: round2.id, match_date: Date.new(2023, 11, 16), home_team_id: teams['Helios'], away_team_id: teams['Strumet'], home_team_score: 5, away_team_score: 4)
match7 = Match.create(round_id: round2.id, match_date: Date.new(2023, 11, 16), home_team_id: teams['Aludyne'], away_team_id: teams['Abb'], home_team_score: 0, away_team_score: 3)
match8 = Match.create(round_id: round2.id, match_date: Date.new(2023, 11, 16), home_team_id: teams['Bezalin'], away_team_id: teams['Pre Zero'], home_team_score: 4, away_team_score: 1)
match9 = Match.create(round_id: round2.id, match_date: Date.new(2023, 11, 16), home_team_id: teams['Dolina Skrzycznego'], away_team_id: teams['Selleo'], home_team_score: 6, away_team_score: 8)
match10 = Match.create(round_id: round2.id, match_date: Date.new(2023, 11, 16), home_team_id: teams['Marion'], away_team_id: teams['Nemak'], home_team_score: 4, away_team_score: 6)
