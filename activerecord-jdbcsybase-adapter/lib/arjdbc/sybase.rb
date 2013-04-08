require 'arjdbc/jdbc'

# This is no longer required and furthermore an error since AR-JDBC 1.2.5
# jdbc_require_driver 'jdbc/sybase'

require 'arjdbc/sybase/connection_methods'
require 'arjdbc/sybase/adapter'

# This is to load the Java parts from their jar
require 'arjdbc/sybase/sybase_java'
