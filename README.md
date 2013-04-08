# ActiveRecord JDBC adapter for SAP Sybase ASE database

## Overview

This is an ActiveRecord JDBC adapter for the [Sybase ASE database](http://www.sybase.com/products/databasemanagement/adaptiveserverenterprise). It is intended to be used in JRuby environment
only and it is an extension of the [ActiveRecord JDBC Adapter project](https://github.com/jruby/activerecord-jdbc-adapter).

This gem requires the [jdbc-sybase gem](https://github.com/SAP/cloud-jdbc-sybase-gem).

The adapter works for Rails 3. It uses [Arel](https://github.com/rails/arel) so it probably won't work with Rails 2.

To install the gem you would have to build it from source:

* `jruby -S gem build activerecord-jdbcsybase-adapter.gemspec`
* `jruby -S gem install activerecord-jdbcsybase-adapter`

	
To use the adapter add the following in your *database.yml* configuration:

    development:
	  adapter: sybase
	  encoding: utf8
	  reconnect: false
	  host: <your_SybaseASE_host>
	  database: <your_SybaseASE_database>
	  pool: 5
	  username: <your_SybaseASE_user_name>
	  password: <your_SybaseASE_password>
	  
JNDI setting is supported as well (this is coming from the generic AR-JDBC Adapter):

    production:
	  adapter: sybase
	  encoding: utf8
	  reconnect: false
	  jndi: java:comp/env/jdbc/mySybaseASEDataSource
	  pool: 5
	  
  

## Contributing

This is an open source project under the Apache 2.0 license, and every contribution is welcome. Issues, pull-requests and other discussions are welcome and expected to take place here. 

## Wiki page

You can check [this wiki page](https://github.com/sap/cloud-activerecord-maxdb-adapter/wiki/Creating-ActiveRecord-JDBC-adapters) for more details of how we created this adapter.
