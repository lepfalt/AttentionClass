class ResponsesController < ApplicationController
  before_action :set_response, only: %i[show update destroy show_grade]

  # GET /responses
  # GET /responses.json
  def index
    @responses = Response.where(user_id: params[:user_id])
    @responses.each do |response|
      check_status_task(response)
      check_status_response(response)
    end
  end

  # GET /responses/1
  # GET /responses/1.json
  def show; end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    if current_user.standard?
      return if !check_status_task(@response)
      check_status_response(@response)
    end

    unless valid_response?
      redirect_to task_response_path(@response)
      return
    end

    if @response.update(response_params)
      if current_user.admin?
        flash[:notice] = "Resposta avaliada com sucesso."
        redirect_to task_responses_path(@response.task_id)
      else
        redirect_to responses_board_path(current_user.id)
      end
    else
      # VER LANÇAMENTO DE ERRO
      # format.html { render :show }
      # format.json { render json: @response.errors, status: :unprocessable_entity }
    end

  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.active = false
    puts 'Erro ao excluir' unless @response.save

    redirect_to responses_board_path(current_user.id)
  end

  def show_grade; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_response
    @response = Response.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def response_params
    params.require(:response).permit(:response_value, :response_annotation, :status, :observation_responsible, :grade)
  end

  def check_status_task(response)
    if response.task.progress? && response.task.expiration_date < Date.today
      close_task(response.task)
      false
    end

    true
  end

  def close_task(task)
    task.status = 2
    puts 'Erro ao concluir tarefa automática no response', task.errors unless task.save
  end

  def check_status_response(response)
    if !response.task.progress? && (response.pending? || response.progress?)
      response.status = 3
      puts 'Erro ao não entregar response', response.errors unless response.save
    end
  end

  def valid_response?
    if current_user.admin?
      unless response_params[:grade].present?
        flash[:notice] = "Campo Nota é obrigatório."
        return false
      end
    end

    true
  end
end
