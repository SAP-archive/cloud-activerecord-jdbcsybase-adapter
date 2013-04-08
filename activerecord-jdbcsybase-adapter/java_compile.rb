CLASSPATH = Dir["#{Java::java.lang.System.getProperty('jruby.home')}/lib/*.jar"].join(File::PATH_SEPARATOR)

# Add to classpath the ActiveRecord JDBC Adapter library to compile against
gem_name = "activerecord-jdbc-adapter"
begin 
  arjdbc_spec = Gem::Specification.find_by_name(gem_name)
rescue Gem::LoadError
  print "It seems that you don't have the #{gem_name} gem installed. Please install it and try again."
  return
end

gem_root = arjdbc_spec.gem_dir
gem_lib = gem_root + "/lib"
CLASSPATH << File::PATH_SEPARATOR + gem_lib + "/arjdbc/jdbc/adapter_java.jar"

jar_name = File.join(*%w(lib arjdbc sybase sybase_java.jar))
directory_name = "classes"

%x(mkdir #{directory_name})
%x(javac -cp #{CLASSPATH} #{Dir['src/java/**/*.java'].join(' ')} -d #{directory_name})
%x(jar -cf #{jar_name} -C #{directory_name} .)