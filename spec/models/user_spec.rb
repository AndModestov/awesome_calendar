require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_length_of(:name).is_at_most(45) }
  it { should have_many(:events).dependent(:destroy) }
end
