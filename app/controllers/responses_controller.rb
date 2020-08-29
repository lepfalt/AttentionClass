class ResponsesController < ApplicationController
  before_action :set_response, only: %i[show update destroy]

  # GET /responses
  # GET /responses.json
  def index
    @responses = Response.all
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
    #upload
    #@response.response_value.attach(params[:response_value])
    if @response.update(response_params)
      redirect_to responses_path
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_response
    @response = Response.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def response_params
    params.require(:response).permit(:response_value, :response_annotation, :status)
  end

  def upload
    puts "FILE ", response_params[:response_value].original_filename
    uploaded_file = response_params[:response_value]
    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end
end
