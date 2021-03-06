require 'spec_helper'

describe Review do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:content) }
  it { should validate_inclusion_of(:rating).in_range(1..5) }

end
