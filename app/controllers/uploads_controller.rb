class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :update, :destroy]

  # GET /uploads
  def index
    @uploads = Upload.all

    render json: @uploads
  end

  # GET /uploads/1
  def show
    render json: @upload
  end

  # POST /uploads
  def create
    @upload = Upload.new(upload_params)
    puts "++++++++++++++++++++++++++++++++++++++++++++++++"
    puts @upload
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++"
    if @upload.save
      render json: @upload, status: :created, location: @upload
    else
      render json: @upload.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /uploads/1
  def update
    if @upload.update(upload_params)
      render json: @upload
    else
      render json: @upload.errors, status: :unprocessable_entity
    end
  end

  # DELETE /uploads/1
  def destroy
    @upload.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def upload_params
      params.require(:upload).permit(:item_type, :item_id, :user_id,:file)
    end
end
