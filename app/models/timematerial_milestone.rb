class TimematerialMilestone < ActiveRecord::Base
  include PublicActivity::Model
  tracked :owner => proc {|o| o.current_user}
  belongs_to :project
  before_save :raise_invoice, :if=>:check_milestone_status?
  before_save :delay_reason_mail
  before_create { self.reason = "" }

  def check_milestone_status?
    return false unless self.status_changed?
    if("raise_invoice".eql?(self.status))
      return true
    else
      return false
    end
  end
  
  def raise_invoice
    emails_to_send
    user_info = {:email=>@emails, :end_date=>self.milestone_end_date, :amount=>self.amount, :milestone_name=>self.milestone_name, :project_name=>@project_name.title, :project_manager=>@project_manager.get_full_detail}
    UserMailer.raise_invoice(user_info).deliver
  end
  
  def emails_to_send
    @emails = []
    @project_name = self.project
    @project_manager = @project_name.project_manager 
    @emails << User.super_admin.email << @project_manager.email
  end
  
  def delay_reason_mail
    return if self.reason.blank?
    if self.reason_changed?
      emails_to_send
      user_info = {:email=>@emails, :pre_start_date=>self.milestone_start_date_was, :cur_start_date=>self.milestone_start_date, :pre_end_date=>self.milestone_end_date_was, :cur_end_date=>self.milestone_end_date, :reason=>self.reason, :milestone_name=>self.milestone_name, :project_name=>@project_name.title, :project_manager=>@project_manager.get_full_detail}
      UserMailer.delayed_reason(user_info).deliver
    end
  end
  
  def update_milestone_date(change_flag, date)
    puts milestone_end_date, self.milestone_end_date.to_date, date
    change_days = (self.milestone_end_date.to_date.to_date - date.to_date)
    timematerial_milestones = self.project.fixed_costs.where("id > #{self.id}")
    unless timematerial_milestones.blank?
      fixed_costs.each do |fc|
        fc.update_attributes(:milestone_start_date=>(fc.milestone_start_date.to_date + change_days), :milestone_end_date=>(fc.milestone_end_date.to_date + change_days))
      end
    end
  end
  
end  