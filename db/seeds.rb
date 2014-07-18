# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Building Company"
    company = Company.create(name: 'Cuelogic', website: 'www.cuelogic.com')
    User.create(firstname: 'Cuelogic', email: CUELOGIC_CONFIG['email'], password: CUELOGIC_CONFIG['password'], password_confirmation: CUELOGIC_CONFIG['password'], company_id: company.id, is_admin: 1 )
    Accessright.create([{name: 'Create Client'},{name: 'Update Client'},{name: 'Remove Client'},{name: 'View Clients'},{name: 'Create Department'},{name: 'Update Department'},{name: 'Remove Department'},{name: 'View Departments'},{name: 'Create Employee'},{name: 'View Employees'},{name: 'Remove Employee'},{name: 'Update Employee'},{name: 'User Access Rights'},{name: 'Create Project'},{name: 'Remove Project'},{name: 'Update Project'},{name: 'View Projects'}])
	TaskType.create([{name: 'Project'},{name: 'Training'},{name: 'Meeting'}])