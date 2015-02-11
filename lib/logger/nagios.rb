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
