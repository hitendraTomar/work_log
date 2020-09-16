require 'csv'
class WorkLog < ApplicationRecord

  # Associations
  belongs_to :user

  # Scopes
  default_scope { order('created_at Desc') }
  scope :work_log_for_today, -> { where(created_at: Date.today.all_day) }
  scope :work_log_for_yesterday, -> {where(created_at: Date.today.yesterday.all_day)}

  # Validations
  validates_presence_of :worklog

  delegate :name, to: :user

  def can_perform_action?(current_user_id)
    (self.class.work_log_for_today.exists? id) && (user_id == current_user_id)
  end


  class << self

    def to_csv(records)
      attributes = ['name', 'worklog', 'created_at']

      CSV.generate(headers: true) do |csv|
        csv << attributes.map(&:camelcase)

        records.each do |object|
          csv << attributes.map{ |attr| object.send(attr) }
        end
      end
    end

    def apply_filters(search)
      return all if search.blank?
      
      query_string = []
      query_string << "created_at >= '#{search[:from_date].to_date}'" if search[:from_date].present?
      query_string << "created_at <= '#{search[:to_date].to_datetime.end_of_day}'" if search[:to_date].present?
      query_string << "user_id = '#{search[:user_id]}'" if search[:user_id].present?
      query_string << "worklog LIKE '%#{search[:worklog]}%'" if search[:worklog].present?

      where(query_string.join(' AND '))
    end

    def set_absent
      user_ids = work_log_for_yesterday.pluck(:user_id)
      User.where.not(id: user_ids).each do |user|
        user.work_logs.create(worklog: "absent", created_at: Date.today.yesterday)
      end
    end
  end

end
