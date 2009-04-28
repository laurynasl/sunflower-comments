# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sunflower-comments}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Laurynas Liutkus"]
  s.date = %q{2009-03-30}
  s.description = %q{Merb Slice that provides sequel + postgres + comments = comment anything (polymorphic, with database triggers)}
  s.email = %q{laurynasl@gmail.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/sunflower-comments.rb", "lib/sunflower-comments", "lib/sunflower-comments/sql", "lib/sunflower-comments/sql/trigger.sql", "lib/sunflower-comments/sql/dynamic.sql", "lib/sunflower-comments/slicetasks.rb", "lib/sunflower-comments/merbtasks.rb", "lib/sunflower-comments/spectasks.rb", "spec/sunflower-comments_spec.rb", "spec/spec_helper.rb", "spec/controllers", "spec/controllers/main_spec.rb", "app/views", "app/views/comments", "app/views/comments/new.html.erb", "app/views/layout", "app/views/layout/sunflower_comments.html.erb", "app/controllers", "app/controllers/comments.rb", "app/controllers/application.rb", "app/helpers", "app/helpers/application_helper.rb", "public/stylesheets", "public/stylesheets/master.css", "public/javascripts", "public/javascripts/master.js", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/main.rb", "stubs/app/controllers/application.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/laurynasl/sunflower-comments/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Merb Slice that provides sequel + postgres + comments = comment anything (polymorphic, with database triggers)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-slices>, [">= 1.0.3"])
    else
      s.add_dependency(%q<merb-slices>, [">= 1.0.3"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 1.0.3"])
  end
end
