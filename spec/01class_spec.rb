#!/usr/bin/env rspec

require 'logger/nagios'

describe Logger::Nagios do

    describe '#new' do

        it 'creates a Logger::Nagios instance' do

            logger = Logger::Nagios.new
            expect(logger).to be_a Logger::Nagios

        end
    end

end
