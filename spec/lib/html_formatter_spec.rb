require 'spec_helper'
require 'cucumber/ast/step'

describe PrettyFace::Formatter::Html do
  let(:step_mother) { double('step_mother') }
  let(:formatter) { Html.new(step_mother, nil, nil) }
  let(:parameter) { double('parameter') }
  let(:step) { Cucumber::Ast::Step.new(1, 'Given', 'A cucumber Step') }

  context "when building the header for the main page" do
    it "should know the start time" do
      formatter.before_features(nil)
      formatter.start_time.should eq Time.now.strftime("%a %B %-d, %Y at %H:%M:%S")
    end
    
    it "should know how long it takes" do
      formatter.should_receive(:generate_report)
      formatter.should_receive(:copy_images_directory)
      formatter.should_receive(:copy_stylesheets_directory)
      formatter.before_features(nil)

      formatter.after_features(nil)
      formatter.total_duration.should include '0.0'
    end
  end

  context "when building the report for scenarios" do
    it "should track number of scenarios" do
      step_mother.should_receive(:scenarios).and_return([1,2,3])
      formatter.scenario_count.should eq 3
    end

    it "should keep track of passing scenarios" do
      step_mother.should_receive(:scenarios).with(:passed).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:passed).should == "2 (100.0%)"
    end

    it "should keep track of failing scenarios" do
      step_mother.should_receive(:scenarios).with(:failed).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:failed).should == "2 (100.0%)"
    end

    it "should keep track of pending scenarios" do
      step_mother.should_receive(:scenarios).with(:pending).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:pending).should == "2 (100.0%)"
    end

    it "should keep track of undefined scenarios" do
      step_mother.should_receive(:scenarios).with(:undefined).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:undefined).should == "2 (100.0%)"
    end

    it "should keep track of skipped scenarios" do
      step_mother.should_receive(:scenarios).with(:skipped).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:skipped).should == "2 (100.0%)"
    end
  end

  context "when building the report for steps" do
    it "should track number of steps" do
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.step_count.should == 2
    end
    
    it "should keep track of passing steps" do
      step_mother.should_receive(:steps).with(:passed).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:passed).should == "2 (100.0%)"
    end

    it "should keep track of failing steps" do
      step_mother.should_receive(:steps).with(:failed).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:failed).should == "2 (100.0%)"
    end

    it "should keep track of skipped steps" do
      step_mother.should_receive(:steps).with(:skipped).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:skipped).should == "2 (100.0%)"
    end

    it "should keep track of pending steps" do 
      step_mother.should_receive(:steps).with(:pending).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:pending).should == "2 (100.0%)"
    end

    it "should keep track of undefined steps" do
      step_mother.should_receive(:steps).with(:undefined).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:undefined).should == "2 (100.0%)"
    end
  end
end
