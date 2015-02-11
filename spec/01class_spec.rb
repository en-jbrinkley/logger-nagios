#!/usr/bin/env rspec

require 'logger/nagios'

describe Logger::Nagios do

    describe '#new' do

        it 'creates a Logger::Nagios instance' do

            logger = Logger::Nagios.new
            expect(logger).to be_a Logger::Nagios
            logger.discard

        end
    end

    context 'severity levels' do

        it 'has constants for severity' do
            require 'logger'
            expect(Logger::Nagios::DEBUG).to eq Logger::DEBUG
            expect(Logger::Nagios::INFO).to eq Logger::INFO
            expect(Logger::Nagios::WARN).to eq Logger::WARN
            expect(Logger::Nagios::ERROR).to eq Logger::ERROR
            expect(Logger::Nagios::FATAL).to eq Logger::FATAL
        end
    end

end
