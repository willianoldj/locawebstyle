# -*- coding: UTF-8 -*-
namespace :deploy do
  @agent = "[Locastyle Robot] says:"

  task :setup, :version do |t, args|
    update_version(args[:version])
    precompile
    package(args[:version])
  end

  def update_version(version)
    File.open(File.join(Rails.root, "app/assets/stylesheets/locastyle_head.css"), "w") do |f|
      f.puts "/*! Locastyle version: #{version}*/"
    end

    File.open(File.join(Rails.root, "app/assets/javascripts/locastyle_head.js"), "w") do |f|
      f.puts "/*! Locastyle version: #{version}*/"
    end
  end

  def package(version)
    puts "#{@agent} Cleaning assets and creating deploy directory..."
    sh %{cp -fr public/assets/ public/deploy/ &&
         cd public/deploy &&
         mv {application,locastyle}.css &&
         mv {application,locastyle}.css.gz &&
         mv {application,locastyle}.js &&
         mv {application,locastyle}.js.gz &&
         rm manifest.yml &&
         rm .DS_Store &&
         rm -r manual/ &&
         rm bootstrap/customize-bootstrap.png &&
         zip -r #{version}.zip . &&
         cp #{version}.zip edge.zip }
    puts "#{@agent} Everything done, version #{version} of Locastyle is ready to upload."
  end

  def precompile
    puts "#{@agent} Compiling assets..."
    Rake::Task["assets:precompile"].invoke
    puts "#{@agent} Assets fully compiled!"
  end

  task :clean do
    puts "#{@agent} Cleaning deployment related files from repo..."
    sh %{rm -r public/deploy/}
    puts "#{@agent} Deployment related files cleaned."
  end
end
