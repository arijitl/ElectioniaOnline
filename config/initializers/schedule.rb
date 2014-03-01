require 'rubygems'
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new

scheduler.cron '25 18 * * *' do
  puts 'Cron Started'
  Game.game_evaluate
  puts 'Cron ended'
end

scheduler.cron '26 18 * * *' do
  puts 'Cron Started'
  WeeklyLeader.add_weekly_leader
  puts 'Cron ended'
end

