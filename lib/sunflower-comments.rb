if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "sunflower-comments/merbtasks", "sunflower-comments/slicetasks", "sunflower-comments/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :sunflower-comments
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:sunflower_comments][:layout] ||= :sunflower_comments
  
  # All Slice code is expected to be namespaced inside a module
  module SunflowerComments
    
    # Slice metadata
    self.description = "SunflowerComments is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "Laurynas Liutkus"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(SunflowerComments)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :sunflower_comments_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      # scope.match('/index(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      # the slice is mounted at /sunflower-comments - note that it comes before default_routes
      # scope.match('/').to(:controller => 'main', :action => 'index').name(:home)
      # enable slice-level default routes by default
      # scope.default_routes
      
      SunflowerComments.classes.each do |klass|
        parent_table = klass.table_name.to_s
        prefix = "/#{parent_table}/:parent_id"
        singular = klass.name.underscore
        hash = {:controller => 'comments', :parent_table => parent_table}

        scope.match(prefix+"/comments", :method => :get).to(hash.merge(:action => 'index')).name(:"#{singular}_comments")
        scope.match(prefix+"/comments", :method => :post).to(hash.merge(:action => 'create')).name(:"#{singular}_comments")
        scope.match(prefix+"/comments/new", :method => :get).to(hash.merge(:action => 'new')).name(:"new_#{singular}_comment")
        scope.match(prefix+"/comments/:id", :method => :get).to(hash.merge(:action => 'show')).name(:"#{singular}_comment")
        scope.match(prefix+"/comments/:id", :method => :put).to(hash.merge(:action => 'update')).name(:"#{singular}_comment")
        scope.match(prefix+"/comments/:id", :method => :delete).to(hash.merge(:action => 'destroy')).name(:"#{singular}_comment")

        scope.match(prefix+"/comments/:id/report", :method => :get).to(hash.merge(:action => 'report')).name(:"report_#{singular}_comment")
      end
    end

    def self.classes
      @@classes ||= []
    end
    def self.classes_hash
      @@classes_hash ||= {}
    end

    module Commentable
      def self.included(other)
        SunflowerComments.classes << other
        SunflowerComments.classes_hash[other.table_name.to_s] = other
        other.has_many :comments, :key => :parent_id, :conditions => {:parent_table => other.table_name.to_s}
      end
    end

    module Comment
      def self.included(other)
        other.validates_presence_of :body, :parent_id, :parent_table
      end

      def parent
        parent_table.camelcase.singular.constantize.filter(:id => parent_id).first
      end
    end
    
  end
  
  # Setup the slice layout for SunflowerComments
  #
  # Use SunflowerComments.push_path and SunflowerComments.push_app_path
  # to set paths to sunflower-comments-level and app-level paths. Example:
  #
  # SunflowerComments.push_path(:application, SunflowerComments.root)
  # SunflowerComments.push_app_path(:application, Merb.root / 'slices' / 'sunflower-comments')
  # ...
  #
  # Any component path that hasn't been set will default to SunflowerComments.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  SunflowerComments.setup_default_structure!
  
  # Add dependencies for other SunflowerComments classes below. Example:
  # dependency "sunflower-comments/other"
  
end
