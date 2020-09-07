class ResponsesController < ApplicationController
  before_action :set_response, only: %i[show update destroy]

  # GET /responses
  # GET /responses.json
  def index
    @responses = Response.where(user_id: params[:user_id])
  end

  # GET /responses/1
  # GET /responses/1.json
  def show; end

  # GET /responses/new
  def new
    @response = Response.new
  end

  # GET /responses/1/edit
  def edit
    puts 'Entrou no edit'
  end

  # POST /responses
  # POST /responses.json
  def create
    @response = Response.new(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to @response, notice: 'Response was successfully created.' }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    # puts 'ENTROU', response_params
    # puts @response.task_id
    # respond_to do |format|
    #@response.response_value.attach(io: File.open('/storage'), filename: response_params[:response_value].original_filename)
    #@response.response_value.attach(params[:response_value])
    task_ajusted? if current_user.admin?

    if @response.update(response_params)
      if current_user.admin?
        redirect_to task_responses_path(@response.task_id)
      else
        redirect_to responses_board_path(current_user.id)
      end
      # format.html { redirect_to responses_path, notice: 'Response was successfully updated.' }
      # format.json { render :show, status: :ok, location: @response }
    else
      format.html { render :show }
      format.json { render json: @response.errors, status: :unprocessable_entity }
    end
    # end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to responses_url, notice: 'Response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def evaluate_response
    puts 'ENTROU'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_response
    @response = Response.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def response_params
    params.require(:response).permit(:response_value, :response_annotation, :status, :observation_responsible, :grade)
  end

  def task_ajusted?
    task = Task.find_by(id: @response.task_id)
    puts 'ENTROU AJUSTED ', task
    task.responses.each do |response|
      return if response.done? && response.grade.blank?
    end
    task.status = 3
    puts 'Erro ', task.errors unless task.save
  end

  def upload
    puts "FILE ", response_params[:response_value].original_filename
    uploaded_file = response_params[:response_value]
    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end
end
