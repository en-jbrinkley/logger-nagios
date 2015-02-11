require "logger/nagios/version"
require "logger"

class Logger

end

class Logger::Nagios

    DEBUG    = Logger::DEBUG
    INFO     = Logger::INFO
    WARN     = Logger::WARN
    ERROR    = Logger::ERROR
    FATAL    = Logger::FATAL

    OK       = 0
    WARNING  = 1
    CRITICAL = 2
    UNKNOWN  = 3

    @@string_status = %w(OK WARNING CRITICAL UNKNOWN)

    @@plugins = []

    at_exit do
        plugin = @@plugins.sort { |a, b| a.status <=> b.status }.first
        if plugin
            if $!.nil? or ($!.is_a?(SystemExit) and $!.success?)
                # We're exiting 'normally', so we go through
                # our plugins and exit as the failest one
                # TODO fix sort logic for UNKNOWN
                puts plugin.output
                Process.exit(plugin.status)
            else
                # We're exiting as a result of something else,
                # probably a fatal exception. We have to
                # exit with UNKNOWN here, and choose the first
                # plugin to be the output
                if $!.respond_to? :backtrace
                    $!.backtrace.each { |line| plugin.error line }
                end

                if $!.respond_to? :message
                    plugin.summary = "#{$0} exiting: #{$!.message}"
                end

                plugin.status = 3
                puts plugin.output
                Process.exit(plugin.status)
            end
        end
    end

    def status_of(severity)
        case severity
        when INFO
            OK
        when WARN
            WARNING
        when ERROR, FATAL
            CRITICAL
        else
            UNKNOWN
        end
    end

    def string_status(status)
        @@string_status[status]
    end

    attr_accessor :status, :summary, :level

    def initialize(service=nil, opt={})
        @opt = opt
        @service = service || File.basename($0)
        @messages = []
        @summary = nil
        @level = INFO
        @status = UNKNOWN
        # Don't really do anything with this flag
        @closed = false

        @@plugins << self # thread safe?
    end

    def discard
        @@plugins.delete self
    end

    def set_status(severity)
        if severity >= INFO
            status = status_of severity
            @status = case @status
                      when UNKNOWN
                          status
                      when OK
                          status == UNKNOWN ? @status : status
                      when WARNING
                          status == CRITICAL ? status : @status
                      when CRITICAL
                          CRITICAL
                      end
        end
        @status
    end

    def log(severity, message, dummy=nil)
        if severity >= @level
            @messages << message
            if severity >= INFO
                @summary = message
            end
        end
        set_status(severity)
    end

    def debug(m, dummy=nil)
        log(DEBUG, m)
    end

    def info(m, dummy=nil)
        log(INFO, m)
    end

    def warn(m, dummy=nil)
        log(WARN, m)
    end

    def error(m, dummy=nil)
        log(ERROR, m)
    end

    def fatal(m, dummy=nil)
        log(FATAL, m)
    end

    def close(summary=nil)
        if summary
            @summary = summary
        end
        @closed = true
    end

    def debug?
        @level <= DEBUG
    end

    def info?
        @level <= INFO
    end

    def warn?
        @level <= WARN
    end

    def error?
        @level <= ERROR
    end

    def fatal?
        @level <= FATAL
    end

    def output
        o = "#{@service} #{string_status(@status)}"
        if @summary
            o << " - #{@summary}"
        end
        unless @messages.empty?
            o << "\n" + @messages.join("\n")
        end
        o
    end

end
