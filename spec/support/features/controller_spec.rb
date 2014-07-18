module ControllerSpecs
  def current_user!(user)
    raise "argument not valid" unless user.is_a?(User)
    controller.stub(:current_user).and_return(user)
  end
end