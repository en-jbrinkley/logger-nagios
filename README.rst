Logger::Nagios
==============

This gem provides a Logger-like interface to Nagios plugin output.
It allows you to "write" Nagios plugin output messages, including
long output, using the Logger interface. It also provides additional
methods to record perfdata.

This is unlike many Nagios helper modules, in that it doesn't help
you run or interpret your check. It doesn't parse command-line
arguments, determine critical or warning thresholds automatically
or work declaratively. What it does do is enable you to turn
many things using a standard Logger class into a Nagios plugin,
and use a Logger style to create a Nagios plugin with a minimum
of Nagios-isms.

The exit status of your plugin will be set by Logger::Nagios
using the **Kernel#at_exit** call. You don't need to do anything
special. The status will always be the "worst" of any Logger::Nagios
objects created.

Logger Methods
--------------

Logger::Nagios.new
~~~~~~~~~~~~~~~~~~

::
   Logger::Nagios.new(servicename, options={})

Creates a new Logger::Nagios object with the given Nagios service name.
The plugin always produces Nagios-compatible output of the form::

  service status - summary|perfdata
  long output

The *long output* is derived from all the log messages passed to
the object. The *service* is the name of the service as given to
the logger, the *status* is a string representation of the Nagios
service status (OK, WARNING, CRITICAL, UNKNOWN), the *summary* is
the plugin summary string (given as the last message logged that
is info or higher and equal to or higher than the logger level;
or given as an argument to close(), or assigned to the **summary**
attribute).

The *perfdata* is provided using the **add_perfdata** method.

The initial status of the plugin is UNKNOWN, i.e., *something* must
be logged in order to make the status meaningful.

level
~~~~~

This determines which messages are added to a plugin's long output.
Messages logged at this level or above are added, messages below
this threshold are not.

close
~~~~~

Mostly a no-op, but if an argument is given, sets the summary line to it.

debug
~~~~~

Logs a message at the DEBUG level and leaves the status and summary alone.

error
~~~~~

Logs a message at the ERROR level, replaces the summary with the message,
and updates the plugin status to CRITICAL.

fatal
~~~~~

Logs a message at the FATAL level, replaces the summary with the message,
and updates the plugin status to CRITICAL.

info
~~~~

Logs a message at the INFO level, replaces the summary with the message
if *level* is INFO or lower, and updates the plugin status to OK if it
is UNKNOWN.

log
~~~

Logs a message at the appropriate level, following the logic described
in the method for that level. Synonym for **add**.

unknown
~~~~~~~

Logs a message unconditionally, replaces the summary with the message,
and updates the plugin status to UNKNOWN. This is also what happens
when the plugin exits unexpectedly. Synonym for **<<**.

warn
~~~~

Logs a message at the WARN level, replaces the summary with the message
if *level* is WARN or lower, and updates the plugin status to WARNING
if is not CRITICAL.

*level*?
~~~~~~~~

The methods **debug?**, **info?**, **warn?**, **error?** and **fatal?**
can be used to query whether a given level is to be logged in the plugin's
long output.
