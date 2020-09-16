class WorkLogsController < ApplicationController

  before_action :load_data_and_apply_filter, only: [:index, :export_csv]
  before_action :fetch_all_work_logs, only: [:new, :edit, :create, :update]
  before_action :set_work_log, only: [:edit, :update, :destroy]
  before_action :can_perform?, only: [:edit, :update, :destroy]

  # Get /work_logs
  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  # Get /work_logs/new
  def new
    @work_log = current_user.work_logs.new if @work_logs.work_log_for_today.blank?
  end

  # GET /work_logs/:id
  def edit
  end

  # POST /work_logs
  def create
    @work_log = current_user.work_logs.new(work_log_params)
    respond_to do |format|
      if @work_log.save
        format.html { redirect_to new_work_log_path, notice: 'Worklog added successfully.' }
      else
        format.html { render :new}
      end
    end
  end

  # PATCH/PUT /work_logs/:id
  def update
    respond_to do |format|
      if @work_log.update(work_log_params)
        format.html { redirect_to new_work_log_path, notice: 'Worklog updated successfully' }
      else
        format.html { render :edit }
      end
    end
  end

  # Delete /work_logs/:id
  def destroy
    @work_log.destroy
    respond_to do |format|
      format.html { redirect_to new_work_log_path, notice: 'Worklog deleted successfully' }
    end
  end

  def export_csv
    respond_to do |format|
      format.csv { send_data WorkLog.to_csv(@work_logs), filename: "work_log.csv" }
    end
  end

  private 

    def load_data_and_apply_filter
      @work_logs = WorkLog.apply_filters(params[:search])
    end
    
    def fetch_all_work_logs
      @work_logs = current_user.work_logs.distinct
    end

    def set_work_log
      @work_log = current_user.work_logs.find_by(id: params[:id])
    end

    def can_perform?
      unless @work_log && @work_log.can_perform_action?(current_user.id)
        respond_to do |format|
          format.html { redirect_back fallback_location: "/", notice: 'Past Worklogs cannot change/delete.' }
        end
      end
    end

    # White List Parameter
    def work_log_params
      params.require(:work_log).permit(:user_id, :worklog)
    end
end
