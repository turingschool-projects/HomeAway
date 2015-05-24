require 'active_record'

namespace :db do
  desc "Load db from pg_dump file"
  task :pg_load, [:pg_file] => :environment do |t, args|
    db_name = ActiveRecord::Base.connection.current_database
    puts "Restting the current state of #{db_name}"
    system("rake db:drop")
    system("rake db:create")
    puts "Loading database #{arg[:pg_file]}..."
    system("psql -d #{db_name} -f test.sql")
  end

  desc "Create a pg_dump file from your dev db in the current rails directory"
  task :pg_dump do
    db_name = ActiveRecord::Base.connection.current_database
    system("pg_dump --no-owner #{db_name} > #{db_name}.sql")
  end
end




# pg_dump --no-owner db/storedom_development > test.sql

# rake db:drop
# rake db:create
# psql -d db/storedom_development -f test.sql

# namespace :samples do
#   desc "Generate a thousand sample articles"
#   task :generate_many => :environment do
#     puts "Generating 1000 sample articles..."
#     Article.generate_samples(1000){ printf "." }
#     puts ""
#   end
#
#   desc "Generate ten thousand comments"
#   task :generate_more_comments => :environment do
#     puts "Generating 10000 sample comments..."
#     10_000.times do
#       article = Article.random
#       Fabricate(:comment, :article => article, :created_at => article.created_at + rand(100).hours)
#       printf '.'
#     end
#     puts ""
#   end
#
# end
