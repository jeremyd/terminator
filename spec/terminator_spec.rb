#! /usr/bin/env bacon
 
require 'rubygems'
require 'bacon'

alias :doing :lambda

describe Terminator do
  
  describe "being given a contract to terminate" do
    it "should not accept an expired contract" do
      doing { Terminator.terminate(0) { "Hello" } }.should.raise(Terminator::Error)
    end
    
    it "should not accept a late contract" do
      doing { Terminator.terminate(-0.1) { "Hello" } }.should.raise(Terminator::Error)
    end
    
    it "should refuse fractions of seconds less than 1" do
      doing { Terminator.terminate(0.1) { "Hello" } }.should.raise(Terminator::Error)
    end

  end

  describe "handling contracts" do
    it "should not kill it's mark if the mark completes" do
      success = false
      Terminator.terminate(10) do
        success = true
      end
      success.should == true
    end

    it "should not terminate it's mark until the time is up" do
      success = false
      Terminator.terminate(10) do
        sleep 0.1
        success = true
      end
      success.should == true
    end
    
    it "should handle multiple sequential contracts gracefully" do
      first_job  = false
      second_job = false
      third_job  = false

      Terminator.terminate(10) do
        first_job = true
      end

      Terminator.terminate(10) do
        second_job = true
      end

      Terminator.terminate(10) do
        third_job = true
      end

      first_job.should == true
      second_job.should == true
      third_job.should == true
    end

    it "should terminate a process that takes too long" do
      first_job  = false

      begin
        Terminator.terminate(1) do
          sleep 10
          first_job = true
        end
      rescue Terminator::Error
        nil
      end

      first_job.should == false
    end

    it "should be a surgical weapon only selectively destroying it's marks" do
      first_job  = false
      second_job = false

      begin
        Terminator.terminate(1) do
          sleep 10
          first_job = true
        end
      rescue 
        nil
      end
      
      Terminator.terminate(10) do
        second_job = true
      end

      first_job.should == false
      second_job.should == true
    end
    
    it "should a surgical weapon only selectively destroying it's marks - backwards" do
      first_job  = false
      second_job = false
      
      Terminator.terminate(10) do
        first_job = true
      end

      begin
        Terminator.terminate(1) do
          sleep 10
          second_job = true
        end
      rescue 
        nil
      end

      first_job.should == true
      second_job.should == false
      
    end
    
    it "should handle many many contracts" do
      success = false
      1000.times do 
        success = false
        Terminator.terminate(1) do
          success = true
        end
      end
      success.should == true
    end
    
    it "should handle many many contracts with a longer attention span" do
      success = false
      5.times do 
        success = false
        Terminator.terminate(5) do
          sleep 1
          success = true
        end
      end
      success.should == true
    end

    it "should handle many many contracts with the last one failing" do
      sleep_time = 0
      begin
        5.times do 
          Terminator.terminate(2) do
            sleep sleep_time
            sleep_time += 1
          end
        end
      rescue Terminator::Error
        nil
      end
      sleep_time.should < 4
    end
    
    it "should be able to pass in a block for arbitrary execution" do
      new_block = lambda { eval("raise(RuntimeError, 'Oops... I failed...')") }
      doing { Terminator.terminate(:seconds => 1, :trap => new_block) { sleep 10 } }.should.raise(RuntimeError)
    end
    
  end

end

BEGIN {
  rootdir = File.split(File.expand_path(File.dirname(File.dirname(__FILE__))))
  libdir = File.join(rootdir, 'lib')
  require File.join(libdir, 'terminator')
}
