activerecord-jdbcsybase-adapter
===========================

This is an ActiveRecord JDBC adapter for Sybase ASE database. Noteworthy parts are:

- `lib/arjdbc/discover.rb`: This file gets loaded by
  activerecord-jdbc-adapter, and where we register our extension.  
- `lib/arjdbc/sybase/adapter.rb`: Organize the ::ArJdbc::SybaseASE code in here.
  In this module we define details for the SQL dialect of Sybase ASE.
- `lib/arjdbc/sybase/connection_methods.rb`: Here, the adapter figures out how to
  interpret database.yml configurations that are targeted at it.
- `lib/active_record/connection_adapters/sybase_adapter.rb`: This
  file is what allows ActiveRecord to load an adapter from its
  `adapter: sybase` line in database.yml.
- `lib/arjdbc/sybase.rb`: Apart from other stuff, this file requires the gem
  that carries the JDBC driver for Sybase ASE. 

