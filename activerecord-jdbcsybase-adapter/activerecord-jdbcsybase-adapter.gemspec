# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name              = 'activerecord-jdbcsybase-adapter'
  s.version           = '0.1'
  s.date              = '2013-02-07'

  s.platform = Gem::Platform.new([nil, "java", nil])
  s.rubyforge_project = %q{jruby-extras}

  s.summary     = "ActiveRecord adapter for Sybase ASE."
  s.description = "ActiveRecord adapter for Sybase ASE. Only for use with JRuby. Requires separate Sybase ASE JDBC driver."

  s.authors  = ["SAP AG"]
  s.email    = 'krum.bakalsky@sap.com'
  s.homepage = 'https://github.com/SAP/cloud-activerecord-jdbcsybase-adapter'
  s.require_paths = %w[lib]
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.md
    Rakefile
    activerecord-jdbcsybase-adapter.gemspec
    lib/active_record/connection_adapters/sybase_adapter.rb
    lib/activerecord-jdbcsybase-adapter.rb
    lib/arel/visitors/sybase.rb
    lib/arjdbc/discover.rb
    lib/arjdbc/sybase.rb
    lib/arjdbc/sybase/adapter.rb
    lib/arjdbc/sybase/connection_methods.rb
    lib/arjdbc/sybase/sybase_java.jar          
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/.*test.*\.rb/ }

  s.add_dependency(%q<activerecord-jdbc-adapter>, [">= 1.0.0"])
  s.add_dependency(%q<jdbc-sybase>, [">= 0.0.0"])

  s.rubygems_version = %q{1.3.7}
  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
  end
end

