class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can :manage, :all
    else  
      user_rights = user.user_permission_names.collect{|i| i.name}
      can :create, Client if user_rights.include?("Create Client")
      can :read, Client if user_rights.include?("View Clients")
      can [:destroy, :read], Client if user_rights.include?("Remove Client")
      can [:update, :read], Client if user_rights.include?("Update Client")
      can :create, Department if user_rights.include?("Create Department")
      can :read, Department if user_rights.include?("View Departments")
      can [:destroy, :read], Department if user_rights.include?("Remove Department")
      can [:update, :read], Department if user_rights.include?("Update Department")
      can :contact_detail, Client if user_rights.include?("View Contact Points")
      can :add_contact_point, Client if user_rights.include?("Add Contact Point")
      can [:read], [User], :user_type => 'contact_point' if user_rights.include?("View Contact Points")
      can [:update, :read], User, :user_type => 'contact_point' if user_rights.include?("Update Contact Point")
      can [:destroy, :contact_detail], [User, Client] if user_rights.include?("Remove Contact Point")
      can :read, User, :user_type => 'employee' if user_rights.include?("View Employees")
      can :create, User, :user_type => 'employee' if user_rights.include?("Create Employee")
      can [:read, :update], User, :user_type => 'employee' if user_rights.include?("Update Employee")      
      can [:read, :destroy], User, :user_type => 'employee' if user_rights.include?("Remove Employee")
      can :get_user_accessright, User if user_rights.include?("User Access Rights")
      can :read, Project if user_rights.include?("View Projects")
      can [:update, :read], Project if user_rights.include?("Update Project")
      can [:destroy, :read], Project if user_rights.include?("Remove Project")
      can :create, Project if user_rights.include?("Create Project")
	  can :list_user_project_detail, User if user_rights.include?("View Team")
	  #can :reporting, User if user_rights.include?("View Reporting")
	  can :project_module, ProjectModule if user_rights.include?("Create Module")
	  can :list_project_modules, ProjectModule if user_rights.include?("View Module list")
	  can :archive_project_module, ProjectModule if user_rights.include?("Remove Module")
	  can [:update_project_module, :show_project_module], ProjectModule if user_rights.include?("Update Module")
	  can :show_project_module, ProjectModule if user_rights.include?("View Module")
	  can :add_timesheet, Timesheet if user_rights.include?("Add Timesheet")
	  
    end  
    # if user.role.name == 'Admin'
    #   can :manage, :all
    #   can :get_user_accessright, :users
    # else
    #   can :read, :all
    # end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
