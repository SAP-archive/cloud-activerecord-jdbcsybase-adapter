require 'arel/visitors/sybase'

module ::ArJdbc
  module SybaseASE    
  
   def self.arel2_visitors(config) 
     { 'jdbc' => ::Arel::Visitors::SybaseASE }
   end

   # Specify the Sybase ASE subclass for the Ruby-JDBC connection.
   # It is to be found in src/java/arjdbc/sybase/SybaseASERubyJdbcConnection.java
   # This is needed for dealing with the 'JZ0NK' issue with jConnect driver and
   # generated keys retrieval.
   def self.jdbc_connection_class
     ::ActiveRecord::ConnectionAdapters::SybaseASEJdbcConnection
   end

   def create_table(name, options = {})
     super(name, options)
     change_non_default_columns_to_be_nullable(name)
   end


   # This is needed because of the default Sybase ASE setting, which is to have
   # NOT NULL on all table columns - the opposite to most other databases.
   #
   # After having created a particular table, we retrieve all the columns in
   # it. We modify each such column, which is not a primary key and which
   # does not have a default value, to be nullable.
   def change_non_default_columns_to_be_nullable(table_name)
     primary_keys = primary_keys(table_name)

     @connection.columns(table_name).each { |column|
       if !column.has_default? && !primary_keys.include?(column.name)
         change_column_null(table_name, column.name, true)
       end
     }
   end

   def drop_table(name)
     super(name)
   end

   def modify_types(tp)
     tp[:string] = { :name => 'VARCHAR', :limit => 255 }
     tp[:text] = { :name => 'VARCHAR', :limit => 5000 }
     tp[:integer] = { :name => 'INTEGER', :limit => nil}
     tp[:primary_key] = "INTEGER IDENTITY PRIMARY KEY CLUSTERED"
     tp[:boolean]     = { :name => 'TINYINT' }
   end

   def add_column(table_name, column_name, type, options = {})
     add_column_sql = "ALTER TABLE #{quote_table_name(table_name)} ADD #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"
     # When we add a column for which default value has not been specified we make the
     # column nullable. Otherwise, by default Sybase ASE will make it NOT NULL, and this
     # will probably fail exactly because there is no DEFAULT clause.
     if !options.has_key?(:default)
       add_column_sql << " NULL"
     end
     add_column_options!(add_column_sql, options)
     execute(add_column_sql)
   end

   def add_column_options!(sql, options)
     options.delete(:default) if options.has_key?(:default) && options[:default].nil?
     sql << " DEFAULT #{quote(options.delete(:default))}" if options.has_key?(:default)
     super
   end

   def change_column_null(table_name, column_name, null)
     if null
       execute "ALTER TABLE #{quote_table_name(table_name)} MODIFY #{quote_column_name(column_name)} NULL"
     else
       execute "ALTER TABLE #{quote_table_name(table_name)} MODIFY #{quote_column_name(column_name)} NOT NULL"
     end
   end

   def add_index(table_name, column_name, options = {})
     statement =  "CREATE"
     statement << " UNIQUE " if options[:unique]
     statement << " INDEX idx_" + "#{table_name}" + "_" + "#{column_name}"
     statement << " ON #{table_name}(#{column_name})"
     execute statement
   end

   # In case we execute an INSERT statement we need to get the auto-generated primary key value.
   # So we call the corresponding 'execute_insert' method exposed by the RubyJdbcConnection class.
   # This code relies that all inserts will be on tables that have IDENTITY primary keys.
   def _execute(sql, name = nil)
     if sql.lstrip =~ /\Ainsert/i
       @connection.execute_insert(sql)
     else
       @connection.execute(sql)
     end
   end

   # Sybase ASE implements some operations using a temporary database called 'tempdb', although
   # the application logic is always operating on its own database. In case there is an active
   # transaction Sybase ASE complains with:
   # The 'CREATE TABLE' command is not allowed within a multi-statement transaction in the 'tempdb' database.
   # See http://infocenter.sybase.com/help/index.jsp?topic=/com.sybase.infocenter.dc32300.1570/html/sqlug/sqlug832.htm
   # That's why we need first to commit the transaction.
   def columns(table_name, name = nil)
     commit_db_transaction
     super(table_name, name)
   end

   # We need column name quoting since some identifiers like the string 'public' are keywords
   # in Sybase ASE and therefore would not be allowed as valid column names.
   def quote_column_name(name)
     "[#{name}]"
   end

   def adapter_name #:nodoc:
     'sybase'
   end
   
  end
end


module ActiveRecord
  module ConnectionAdapters

    class SybaseASEColumn < JdbcColumn
      def default_value(val)
        val
      end
    end

    class SybaseASESQLAdapter < JdbcAdapter
      include ArJdbc::SybaseASE
      def jdbc_column_class
        ActiveRecord::ConnectionAdapters::SybaseASEColumn
      end

      def jdbc_connection_class(spec)
        ::ArJdbc::SybaseASE.jdbc_connection_class
      end

    end

  end
end