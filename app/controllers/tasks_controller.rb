class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy,:assign_task ,:toggle_state,:task_timeline]

  # GET /tasks
  def index
    if params[:meeting_id].present?
      @tasks = Task.where(meeting_id:params[:meeting_id])
    else
      meetings=@current_user.meetings.pluck(:id)
      @tasks=Task.where(meeting_id:meetings)
      # @tasks=Task.where(meeting_id:1)
    end
    tasks=[]
    @tasks.each do |task|
      t=task.as_json
      if task.status=="completed"
        t["completed"]=true
      else
        # t["completed"]=false
      end

      if task.due_date.present?
        t["due_date"]=task.due_date.strftime("%d/%m/%Y")
        if task.due_date>=Time.new(Date.today.year,Date.today.month,Date.today.day) && task.due_date<=Time.new(Date.today.year,Date.today.month,Date.today.day,23,59)
          t["scheduled"]=true
        else
          if task.due_date.strftime("%d/%m/%Y")==Date.tomorrow.strftime("%d/%m/%Y")
            t["scheduled_tomorrow"]=true
          end
        end

        if task.assignee_id.present?
          t["assignee"]=task.assignee.name
        else
          t["assignee"]=""
        end
      end


      tasks<<t

    end
    puts @tasks.count
    render json: tasks
  end

  # GET /tasks/1
  def show
    task={}
    task=@task.as_json
    # task['assignee_name']=@task.assignee.name
    # task['assigner_name']=@task.assigner_name
    comments_by_user=[]
    my_notes=[]
    @task.comments.each do |comment|
      if comment.comment_type!="note"
        comments_by_user.push({'content':comment.content,'commentor_name':comment.user.name,'created_at':comment.created_at})
      else
        my_notes.push({'content':comment.content,'created_at':comment.created_at})
      end
    end
    task["comments_by_user"]=comments_by_user
    task["my_notes"]=my_notes
    task['upload']=[]
    @task.uploads.each do |upload|
      task['upload'].append({'filename':upload.file.blob.filename.to_s,file_url:upload.file.blob.service_url})
    end
    # task['timeline']=@task.get_timeline()
    render json: task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.assigner_id=@current_user.id
    due_date=params[:task][:due_date].to_date
    @task.due_date=Time.new(due_date.year,due_date.month,due_date.day)

    if @task.save
      if params[:file_ids].present?
        params[:file_ids].each do |file_id|
          Upload.find(file_id).update(item_type:"Task",item_id:@task.id)
        end
      end
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  def assign_task
    @task.allocate_assignee(params[:assignee_id])
    render json:{success:true}
  end

  def toggle_state
      new_state=@task.toggle_state(@current_user.id)
    render json:{success:true,new_state:new_state}
  end

  def task_timeline
     render json: @task.get_timeline
  end




  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task).permit(:meeting_id, :description, :due_date, :status, :flag,:assignee_id)
  end
end
