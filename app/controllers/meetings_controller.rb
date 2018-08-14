class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :update, :destroy]

  # GET /meetings
  def index
    # @meetings = @current_user.meetings.order("created_at DESC")
    @meetings = Meeting.all
    meetings=[]
    @meetings.each do |meeting|
      m=meeting.as_json
      if meeting.scheduled_time.present?
        if meeting.scheduled_time>=DateTime.now.at_beginning_of_day&& meeting.scheduled_time<=DateTime.now.end_of_day
          m["scheduled"]=true
        # else
          # m["scheduled"]=false
        end
      end
      meetings<<m
    end
    puts @meetings.count
    render json: meetings
  end

  # GET /meetings/1
  def show
    render json: @meeting
  end

  # POST /meetings
  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.created_by_id=@current_user.id

    if @meeting.save
      UserMeeting.create(user_id:@current_user.id,meeting_id:@meeting.id)
      if params[:attendess].present?
        params[:attendess].each do |attendee|
          UserMeeting.create(user_id:attendee,meeting_id:@meeting.id)
        end
      end
      render json: @meeting, status: :created, location: @meeting
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /meetings/1
  def update
    if @meeting.update(meeting_params)
      render json: @meeting
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  # DELETE /meetings/1
  def destroy
    @meeting.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def meeting_params
    params.require(:meeting).permit(:description, :scheduled_time, :start_time, :end_time)
  end
end
