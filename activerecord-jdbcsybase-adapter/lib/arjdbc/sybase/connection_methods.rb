class ActiveRecord::Base
  class << self
    def sybase_connection( config )
      config[:port] ||= 5000
      config[:url] ||= "jdbc:sybase:Tds:#{config[:host]}:#{config[:port]}/#{config[:database]}"
      config[:driver] ||= "com.sybase.jdbc4.jdbc.SybDriver"
      config[:adapter_class] = ActiveRecord::ConnectionAdapters::SybaseASESQLAdapter
      config[:adapter_spec] = ::ArJdbc::SybaseASE
      jdbc_connection(config)
    end
  end
end