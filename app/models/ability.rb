class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  protected

  def guest_abilities
  end

  def user_abilities
    can :read, :all
    can :create, Event
    can :update, Event, user_id: user.id
  end
end
