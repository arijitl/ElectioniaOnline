require 'rubygems'
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new

scheduler.cron '55 12 * * *' do
  puts 'Cron Started'
  puts 'Cron ended'
end

