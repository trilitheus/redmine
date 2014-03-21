chef_api :config

site :opscode

metadata

def internal_cookbook(name, version = '>= 0.0.0', options = {})
  cookbook(name, version, {
    git: "http://gitlab-prd-ict01.ad.lancscc.net/chef-cookbooks/#{name}.git"
  }.merge(options))
end
