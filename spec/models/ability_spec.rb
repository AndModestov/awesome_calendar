require 'rails_helper'

describe Ability do
  subject(:ability){ Ability.new(user) }

  describe 'for guest' do
    let(:user){ nil }

    it { should_not be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user){ create(:user) }
    let(:event){ create(:event, user: user) }
    let(:other_user){ create(:user) }
    let(:other_event){ create(:event, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Event }

    it { should be_able_to :update, event }
    it { should_not be_able_to :update, other_event }

    # it { should be_able_to :destroy, event }
    # it { should_not be_able_to :destroy, other_event }
  end
end
