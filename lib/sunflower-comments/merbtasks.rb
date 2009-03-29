namespace :slices do
  namespace :sunflower_comments do
  
    desc "Install SunflowerComments"
    task :install => [:preflight, :setup_directories, :copy_assets, :migrate]
    
    desc "Test for any dependencies"
    task :preflight do # see slicetasks.rb
    end
  
    desc "Setup directories"
    task :setup_directories do
      puts "Creating directories for host application"
      SunflowerComments.mirrored_components.each do |type|
        if File.directory?(SunflowerComments.dir_for(type))
          if !File.directory?(dst_path = SunflowerComments.app_dir_for(type))
            relative_path = dst_path.relative_path_from(Merb.root)
            puts "- creating directory :#{type} #{File.basename(Merb.root) / relative_path}"
            mkdir_p(dst_path)
          end
        end
      end
    end
    
    desc "Copy stub files to host application"
    task :stubs do
      puts "Copying stubs for SunflowerComments - resolves any collisions"
      copied, preserved = SunflowerComments.mirror_stubs!
      puts "- no files to copy" if copied.empty? && preserved.empty?
      copied.each { |f| puts "- copied #{f}" }
      preserved.each { |f| puts "! preserved override as #{f}" }
    end
    
    desc "Copy stub files and views to host application"
    task :patch => [ "stubs", "freeze:views" ]
  
    desc "Copy public assets to host application"
    task :copy_assets do
      puts "Copying assets for SunflowerComments - resolves any collisions"
      copied, preserved = SunflowerComments.mirror_public!
      puts "- no files to copy" if copied.empty? && preserved.empty?
      copied.each { |f| puts "- copied #{f}" }
      preserved.each { |f| puts "! preserved override as #{f}" }
    end
    
    desc "Migrate the database"
    task :migrate do # see slicetasks.rb
    end
    
    desc "Freeze SunflowerComments into your app (only sunflower-comments/app)" 
    task :freeze => [ "freeze:app" ]

    namespace :freeze do
      
      desc "Freezes SunflowerComments by installing the gem into application/gems"
      task :gem do
        ENV["GEM"] ||= "sunflower-comments"
        Rake::Task['slices:install_as_gem'].invoke
      end
      
      desc "Freezes SunflowerComments by copying all files from sunflower-comments/app to your application"
      task :app do
        puts "Copying all sunflower-comments/app files to your application - resolves any collisions"
        copied, preserved = SunflowerComments.mirror_app!
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freeze all views into your application for easy modification" 
      task :views do
        puts "Copying all view templates to your application - resolves any collisions"
        copied, preserved = SunflowerComments.mirror_files_for :view
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freeze all models into your application for easy modification" 
      task :models do
        puts "Copying all models to your application - resolves any collisions"
        copied, preserved = SunflowerComments.mirror_files_for :model
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freezes SunflowerComments as a gem and copies over sunflower-comments/app"
      task :app_with_gem => [:gem, :app]
      
      desc "Freezes SunflowerComments by unpacking all files into your application"
      task :unpack do
        puts "Unpacking SunflowerComments files to your application - resolves any collisions"
        copied, preserved = SunflowerComments.unpack_slice!
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
    end
    
  end
end