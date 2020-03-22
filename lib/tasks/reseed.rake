# frozen_string_literal: true

namespace :db do
  desc 'Clears the database and reseeds it using the seeds file.'
  task :reseed do
    Rake::Task['db:migrate:reset'].invoke && Rake::Task['db:seed'].invoke
  end
end
