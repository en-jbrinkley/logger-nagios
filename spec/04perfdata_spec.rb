#!/usr/bin/env rspec

describe Logger::Nagios do

    describe "#add_perfdata" do

        before(:each) { @logger = Logger::Nagios.new 'utest' }
        after(:each) { @logger.discard }

        it "adds a simple perfdata item" do
            @logger.add_perfdata('time0', 10)
            expect(@logger.perfdata).to eq "time0=10"
        end

        it "adds a perfdata item with units" do
            @logger.add_perfdata('time0', 10, :unit => 's')
            expect(@logger.perfdata).to eq "time0=10s"
        end

        it "adds a perfdata item with spaces" do
            @logger.add_perfdata('time 0', 10)
            expect(@logger.perfdata).to eq "'time 0'=10"
        end

        it "adds a perfdata item with equals" do
            @logger.add_perfdata('time=0', 10)
            expect(@logger.perfdata).to eq "'time=0'=10"
        end

        it "adds multiple perfdata items" do
            @logger.add_perfdata('time0', 10)
            @logger.add_perfdata('time5', 15)
            expect(@logger.perfdata).to eq "time0=10 time5=15"
        end

        it "adds a perfdata item with thresholds" do
            @logger.add_perfdata('time0', 10, :warn => 20, :crit => 30)
            expect(@logger.perfdata).to eq "time0=10;20;30"
        end

        it "adds a perfdata item with min/max" do
            @logger.add_perfdata('time0', 10, :min => 0, :max => 60)
            expect(@logger.perfdata).to eq "time0=10;;;0;60"
        end

        it "adds perfdata in the output" do
            @logger.info "all systems go"
            @logger.add_perfdata('time0', 10, :unit => 's')
            @logger.add_perfdata('time 5', 15, :unit => 's', :warn => 30, :crit => 50)
            expect(@logger.output).to eq "utest OK - all systems go|time0=10s 'time 5'=15s;30;50\nall systems go"
        end
    end
end

