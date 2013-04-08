package arjdbc.sybase;

import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyModule;
import org.jruby.runtime.load.BasicLibraryService;

import arjdbc.jdbc.RubyJdbcConnection;


/**
 * This is a custom JRuby load service, intended to define the class for the Sybase ASE Ruby JDBC Connection.
 * You can take a look at the service interface here: http://www.jruby.org/apidocs/org/jruby/runtime/load/BasicLibraryService.html
 * <br>
 * <br>
 * This class has to be compiled and packaged in a jar, called lib/arjdbc/sybase/sybase_java.jar, which is then being loaded from
 * lib/arjdbc/sybase.rb
 * <br>
 * <br>
 * There is a naming convention as well in order for this jar to be discovered and picked up from JRuby's load path: see more at
 * http://jruby.org/apidocs/org/jruby/runtime/load/LoadService.html.
 * Since the jar name is 'sybase_java.jar' the service name should be its corresponding camel case: SybaseJavaService.
 */
public class SybaseJavaService implements BasicLibraryService  {

	@Override
	public boolean basicLoad(Ruby runtime) throws IOException {

		// Because we do not know the order into which the library services will be called, we first check whether the Ruby runtime has already
		// been defined a class with name 'JdbcConnection'. This can happen if the arjdbc.jdbc.AdapterJavaService is called first.
		RubyClass jdbcConnection  = ((RubyModule) runtime.getModule("ActiveRecord").getConstant("ConnectionAdapters")).getClass("JdbcConnection");

		if (jdbcConnection == null) {
			// if no such class exists, then we create it
			jdbcConnection = RubyJdbcConnection.createJdbcConnectionClass(runtime);
		}

		SybaseASERubyJdbcConnection.createSybaseASEJdbcConnectionClass(runtime, jdbcConnection);
		return true;
	}
}