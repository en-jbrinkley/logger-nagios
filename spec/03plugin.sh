#!/usr/bin/env bats

@test "initialization" {
    run ruby -Ilib -rlogger/nagios -e 'log = Logger::Nagios.new "utest"'
    [ $status -eq 3 ]
    [ "$output" = "utest UNKNOWN" ]
}

@test "normal operation" {
    run ruby -Ilib -rlogger/nagios \
        -e 'log = Logger::Nagios.new "utest"' \
        -e 'log.info "test info message"'
    [ $status -eq 0 ]
    [ "${lines[0]}" = "utest OK - test info message" ]
    [ "${lines[1]}" = "test info message" ]
}

@test "uncontrolled errors" {
    run ruby -Ilib -rlogger/nagios \
        -e 'log = Logger::Nagios.new "utest"' \
        -e 'log.info "test info message"' \
        -e 'foo.each { |x| puts x }'
    [ $status -eq 3 ]
}

@test "warnings" {
    run ruby -Ilib -rlogger/nagios \
        -e 'log = Logger::Nagios.new "utest"' \
        -e 'log.warn "test warn message"'
    [ $status -eq 1 ]
    [ "${lines[0]}" = "utest WARNING - test warn message" ]
}

@test "criticals" {
    run ruby -Ilib -rlogger/nagios \
        -e 'log = Logger::Nagios.new "utest"' \
        -e 'log.error "test error message"'
    [ $status -eq 2 ]
    [ "${lines[0]}" = "utest CRITICAL - test error message" ]
}


