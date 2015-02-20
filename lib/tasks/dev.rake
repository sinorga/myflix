# -*- encoding : utf-8 -*-
namespace :dev do

  desc "Rebuild system"
  task :build => ["tmp:clear", "dev:clean_upload", "log:clear", "db:drop", "db:create", "db:migrate", "db:seed" ]

  desc "clean uploads"
  task :clean_upload => :environment do
    FileUtils.rm_rf(Dir[Rails.root.join('public', 'uploads')])
  end
end
