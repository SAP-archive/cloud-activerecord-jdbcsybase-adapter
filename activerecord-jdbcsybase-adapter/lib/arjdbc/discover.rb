# arjdbc/discover.rb: Declare ArJdbc.extension modules in this file
# that loads a custom module and adapter.

module ::ArJdbc  
  extension :SybaseASE do |name|  
    require 'arjdbc/sybase'
    name =~ /sybase/i
    true
  end
end
