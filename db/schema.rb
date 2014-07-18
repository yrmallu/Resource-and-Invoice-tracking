# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140307123103) do

  create_table "accessrights", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accessrights_roles", id: false, force: true do |t|
    t.integer "accessright_id"
    t.integer "role_id"
  end

  create_table "accessrights_roles_users", id: false, force: true do |t|
    t.integer "accessright_id"
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "addresses", force: true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "telephone_number"
    t.string   "mobile"
    t.string   "fax_no"
    t.string   "address_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "website"
    t.text     "description"
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photos_file_name"
    t.string   "photos_content_type"
    t.string   "photos_file_size"
    t.datetime "photos_updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.string   "domain"
    t.string   "telephone_number"
    t.string   "mobile"
    t.string   "image_name"
    t.string   "image_type"
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "departments", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["name"], name: "index_departments_on_name", unique: true, using: :btree

  create_table "fixed_costs", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "milestone_name"
    t.date     "milestone_start_date"
    t.date     "milestone_end_date"
    t.string   "status"
    t.text     "description"
    t.float    "amount"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reason"
  end

  create_table "module_timesheets", force: true do |t|
    t.integer  "project_module_id"
    t.integer  "timesheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.string   "title"
    t.string   "notification_type"
    t.text     "template"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_contacts", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
    t.boolean  "is_billable"
    t.boolean  "is_verified", default: false
  end

  create_table "project_files", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "file_name"
    t.string   "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "files_file_name"
    t.string   "files_content_type"
    t.string   "files_file_size"
    t.datetime "files_updated_at"
  end

  create_table "project_modules", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_modules_timesheets", id: false, force: true do |t|
    t.integer "project_module_id"
    t.integer "timesheet_id"
  end

  create_table "project_notifications", force: true do |t|
    t.integer  "project_id"
    t.integer  "notification_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "title"
    t.integer  "client_id"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "project_type"
    t.text     "description"
    t.boolean  "delete_flag"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.float    "total_amount"
    t.float    "advanced_amount"
    t.float    "sign_off_amount"
    t.integer  "no_of_milestones"
    t.date     "starting_date"
    t.integer  "committed_hours"
  end

  create_table "projects_users", id: false, force: true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "public_holidays", force: true do |t|
    t.string   "name"
    t.date     "holiday_date"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "task_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "project_module_id"
    t.integer  "timesheet_id"
    t.date     "task_date"
    t.text     "description"
    t.float    "hours"
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "task_type_id"
  end

  create_table "technologies", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technologies_users", id: false, force: true do |t|
    t.integer "technology_id"
    t.integer "user_id"
  end

  create_table "time_materials", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.float    "rate_per_hour"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "rate_start_date"
    t.date     "rate_end_date"
    t.boolean  "is_active"
  end

  create_table "timematerial_milestones", force: true do |t|
    t.integer  "project_id"
    t.string   "milestone_name"
    t.date     "milestone_start_date"
    t.date     "milestone_end_date"
    t.string   "status"
    t.text     "description"
    t.float    "amount"
    t.string   "currency"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "title"
    t.float    "total_hours"
    t.date     "timesheet_date"
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_accessrights", force: true do |t|
    t.integer  "user_id"
    t.integer  "accessright_id"
    t.boolean  "access_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "user_type"
    t.string   "skype_id"
    t.string   "hangout_id"
    t.string   "emp_code"
    t.string   "gender"
    t.integer  "role_id"
    t.integer  "boss_id"
    t.integer  "department_id"
    t.date     "joining_date"
    t.float    "experience"
    t.text     "technology"
    t.string   "education"
    t.date     "date_of_birth"
    t.boolean  "delete_flag"
    t.boolean  "access_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_name"
    t.string   "image_type"
    t.string   "password_digest"
    t.integer  "client_id"
    t.string   "photos_file_name"
    t.string   "photos_content_type"
    t.string   "photos_file_size"
    t.datetime "photos_updated_at"
    t.boolean  "is_admin"
    t.string   "resource_type"
    t.integer  "company_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
