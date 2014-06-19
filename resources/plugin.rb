actions :install, :remove
default_action :install

attribute :name,            :name_attribute => true,
                            :kind_of => String,
                            :required => true

attribute :source,          :kind_of => String,
                            :required => true

attribute :source_type,     :kind_of => String,
                            :default => 'git'

attribute :revision,        :kind_of => String,
                            :default => 'master'

attribute :run_bundler,     :kind_of => [TrueClass, FalseClass],
                            :default => false

attribute :restart_redmine, :kind_of => [TrueClass, FalseClass],
                            :default => false

attribute :run_migrations,  :kind_of => [TrueClass, FalseClass],
                            :default => false

attr_accessor :exists
