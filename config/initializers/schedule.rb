require 'rubygems'
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new

scheduler.cron '55 15 * * *' do
  puts 'Cron Started'
  Game.game_evaluate
  puts 'Cron ended'
end

