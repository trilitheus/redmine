actions :install, :remove
default_action :install

attribute :name, :name_attribute => true,
                 :kind_of => String,
                 :required => true

attribute :source, :required => true,
                   :kind_of => String

attribute :source_type, :required => true,
                        :kind_of => String,
                        :default => 'git'

attr_accessor :exists
