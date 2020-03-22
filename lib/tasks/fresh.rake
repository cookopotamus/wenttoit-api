# frozen_string_literal: true

namespace :db do
  desc 'Drops the database, creates it, runs migrations, and then seeds it using the seeds file.'
  task :fresh do
    Rake::Task['db:drop'].invoke && Rake::Task['db:create'].invoke && Rake::Task['db:migrate'].invoke && Rake::Task['db:seed'].invoke
  end
end
