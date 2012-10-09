require 'spec_helper'

describe Compo do
  before(:each) do
    FactoryGirl.create(:compo)
  end

  it { should validate_presence_of(:slots) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:group_size) }
  it { should belong_to(:game) }
  it { should have_many(:prices) }
  it { should have_many(:matches) }
end