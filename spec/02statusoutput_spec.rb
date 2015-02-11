#!/usr/bin/env rspec

describe Logger::Nagios do

    before(:each) { @logger = Logger::Nagios.new('utest') }

    context "when updating status" do

        it "starts with unknown status" do
            expect(@logger.status).to eq 3
        end

        it "is unchanged for debug logging" do
            @logger.debug "test debug message"
            expect(@logger.status).to eq 3
        end

        it "is OK for info logging" do
            @logger.info "test info message"
            expect(@logger.status).to eq 0
        end

        it "is WARNING for warn logging" do
            @logger.warn "test warn message"
            expect(@logger.status).to eq 1
        end

        it "is CRITICAL for error logging" do
            @logger.error "test error message"
            expect(@logger.status).to eq 2
        end

        it "is CRITICAL for fatal logging" do
            @logger.fatal "test fatal message"
            expect(@logger.status).to eq 2
        end

        it "stays WARNING when logging info" do
            @logger.warn "test warn message"
            @logger.info "test info message"
            expect(@logger.status).to eq 1
        end

    end

    context "when recording output" do

        it "starts with UNKNOWN summary" do
            expect(@logger.summary).to be_nil
            expect(@logger.output).to eq 'utest UNKNOWN'
        end

        it "records updated OK summary" do
            @logger.info "test info message"
            expect(@logger.summary).to eq "test info message"
            expect(@logger.output).to eq "utest OK - test info message\ntest info message"
        end

        it "records updated WARNING summary" do
            @logger.warn "test warn message"
            expect(@logger.output).to eq "utest WARNING - test warn message\ntest warn message"
        end

        it "records updated CRITICAL summary" do
            @logger.error "test error message"
            expect(@logger.output).to eq "utest CRITICAL - test error message\ntest error message"
        end

        it "records multiple messages" do
            @logger.info "test info message"
            @logger.warn "test warn message"
            expect(@logger.output).to eq "utest WARNING - test warn message\ntest info message\ntest warn message"
        end

    end

    context "when specifying level" do

        it "ignores messages (but not status update) for below-threshold messages" do
            @logger.level = Logger::Nagios::WARN
            @logger.info "test info message"
            expect(@logger.summary).to be_nil
            expect(@logger.output).to eq "utest OK"
        end

        it "logs messages for above-threshold messages" do
            @logger.level = Logger::Nagios::WARN
            @logger.info "test info message"
            @logger.warn "test warn message"
            expect(@logger.output).to eq "utest WARNING - test warn message\ntest warn message"
        end

    end

    context "when setting attributes" do

        it "sets status unconditionally" do
            @logger.warn "test warn message"
            @logger.status = 0
            expect(@logger.status).to eq 0
            expect(@logger.output).to eq "utest OK - test warn message\ntest warn message"
        end

        it "sets summary unconditionally" do
            @logger.info "test info message"
            @logger.summary = "test summary"
            expect(@logger.status).to eq 0
            expect(@logger.output).to eq "utest OK - test summary\ntest info message"
        end

    end

end
