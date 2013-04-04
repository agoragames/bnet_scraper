require 'spec_helper'

describe BnetScraper::Starcraft2::Portrait do
  subject { BnetScraper::Starcraft2::Portrait.new(3, 90, 360, 0) }
  its(:name) { should == 'Selendis' }
  its(:sheet) { should == 3 }
  its(:row) { should == 0 }
  its(:column) { should == 4 }
  its(:image_position) { should == 4 }
  its(:url) { should == 'http://media.blizzard.com/sc2/portraits/3-4.jpg' }
  its(:spritesheet_url) { should == 'http://media.blizzard.com/sc2/portraits/3-90.jpg' }
end
