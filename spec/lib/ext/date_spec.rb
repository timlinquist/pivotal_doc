require 'spec_helper'

describe Date do
  before(:each) do
    @date= Date.parse('1-1-2010')
  end
  
  it "have a standard format" do
    @date.standard_format.should eql('01-01-2010')
  end
  
  it "have a fancy format" do
    @date.fancy_format.should eql('Jan 01, 2010')
  end
end
