require 'spec_helper'

describe Guard::RSpec::Runner do
  subject { Guard::RSpec::Runner }

  describe "run" do
    
    context "in empty folder" do
      before(:each) do
        Dir.stub(:pwd).and_return(@fixture_path.join("empty"))
        subject.set_rspec_version
      end
      
      it "should run with RSpec 2 and without bundler" do
        subject.should_receive(:system).with(
          "rspec --require #{@lib_path.join('guard/rspec/formatters/default_rspec.rb')} --format DefaultRSpec --color spec"
        )
        subject.run(["spec"])
      end
      
      it "should run with drb argument" do
        subject.should_receive(:system).with(
          "rspec --require #{@lib_path.join('guard/rspec/formatters/default_rspec.rb')} --format DefaultRSpec --drb --color spec"
        )
        subject.run(["spec"], :drb => true)
      end
      
      it "should run with rvm exec" do
        subject.should_receive(:system).with(
          "rvm 1.8.7,1.9.2 exec rspec --require #{@lib_path.join('guard/rspec/formatters/default_rspec.rb')} --format DefaultRSpec --color spec"
        )
        subject.run(["spec"], :rvm => ['1.8.7', '1.9.2'])
      end
      
      it "should run without color argument" do
        subject.should_receive(:system).with(
          "rspec --require #{@lib_path.join('guard/rspec/formatters/default_rspec.rb')} --format DefaultRSpec spec"
        )
        subject.run(["spec"], :color => false)
      end
      
      it "should run with instafail formatter" do
        subject.should_receive(:system).with(
          "rspec --require #{@lib_path.join('guard/rspec/formatters/instafail_rspec.rb')} --format InstafailRSpec --color spec"
        )
        subject.run(["spec"], :formatter => "instafail")
      end
      
      it "should run with fail-fast argument" do
        subject.should_receive(:system).with(
          "rspec --require #{@lib_path.join('guard/rspec/formatters/default_rspec.rb')} --format DefaultRSpec --color --fail-fast spec"
        )
        subject.run(["spec"], :fail_fast => true)
      end
    end
    
    context "in RSpec 1 folder" do
      before(:each) do
        Dir.stub(:pwd).and_return(@fixture_path.join("rspec1"))
        subject.set_rspec_version
      end
      
      it "should run with RSpec 1 and with bundler" do
        subject.should_receive(:system).with(
          "bundle exec spec --require #{@lib_path.join('guard/rspec/formatters/default_spec.rb')} --format DefaultSpec --color spec"
        )
        subject.run(["spec"])
      end
      
      it "should run with instafail formatter" do
        subject.should_receive(:system).with(
          "bundle exec spec --require #{@lib_path.join('guard/rspec/formatters/instafail_spec.rb')} --format InstafailSpec --color spec"
        )
        subject.run(["spec"], :formatter => "instafail")
      end
      
      it "should run without bundler with bundler option to false" do
        subject.should_receive(:system).with(
          "spec --require #{@lib_path.join('guard/rspec/formatters/default_spec.rb')} --format DefaultSpec --color spec"
        )
        subject.run(["spec"], :bundler => false)
      end
    end
    
  end
  
  describe "set_rspec_version" do
    
    it "should use version option first" do
      subject.set_rspec_version(:version => 1)
      subject.rspec_version.should == 1
    end
    
    context "in empty folder" do
      before(:each) { Dir.stub(:pwd).and_return(@fixture_path.join("empty")) }
      
      it "should set RSpec 2 because cannot determine version" do
        subject.set_rspec_version
        subject.rspec_version.should == 2
      end
    end
    
    context "in RSpec 1 with bundler only folder" do
      before(:each) { Dir.stub(:pwd).and_return(@fixture_path.join("bundler_only_rspec1")) }
      
      it "should set RSpec 1 from Bundler" do
        subject.set_rspec_version
        subject.rspec_version.should == 1
      end
    end
    
    context "in RSpec 2 with bundler only folder" do
      before(:each) { Dir.stub(:pwd).and_return(@fixture_path.join("bundler_only_rspec2")) }
      
      it "should set RSpec 2 from Bundler" do
        subject.set_rspec_version
        subject.rspec_version.should == 2
      end
    end
    
    context "in RSpec 1" do
      before(:each) { Dir.stub(:pwd).and_return(@fixture_path.join("rspec1")) }
      
      it "should set RSpec 1 from spec_helper.rb" do
        subject.set_rspec_version
        subject.rspec_version.should == 1
      end
    end
    
    context "in RSpec 2" do
      before(:each) { Dir.stub(:pwd).and_return(@fixture_path.join("rspec2")) }
      
      it "should set RSpec 2 from spec_helper.rb" do
        subject.set_rspec_version
        subject.rspec_version.should == 2
      end
    end
  end
  
end
