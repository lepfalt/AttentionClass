class ResponsesController < ApplicationController
  before_action :set_response, only: %i[show update destroy show_grade]

  # GET /responses
  # GET /responses.json
  def index
    @responses = Response.where(user_id: params[:user_id])
    udpate_responses
  end

  # GET /responses/1
  # GET /responses/1.json
  def show; end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    return unless check_update_reponses?
    return unless valid_response_by_admin?

    if @response.update(response_params)
      if current_user.admin?
        handler_notice("Resposta avaliada com sucesso.", task_responses_path(@response.task_id))
      else
        handler_notice("Resposta salva com sucesso.", responses_board_path(current_user.id))
      end
    else
      handler_notice_error("Erro ao atualizar resposta.", response_path(@response))
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.active = false
    if @response.save
      handler_notice_error("Resposta excluída com sucesso", responses_board_path(current_user.id))
    else
      handler_notice_error("Erro ao excluir resposta.", responses_board_path(current_user.id))
    end
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

  def udpate_responses
    @responses.each do |response|
      check_status_task(response)
      check_status_response(response)
    end
  end

  def check_update_reponses?
    if current_user.standard?
      return false unless check_status_task(@response)
      return false unless check_status_response(@response)
    end

    true
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
      unless response.save
        puts 'Erro ao não entregar response', response.errors
        return false
      end
    end

    true
  end

  def valid_response_by_admin?
    if current_user.admin?
      unless response_params[:grade].present?
        handler_notice("Campo Nota é obrigatório.", task_response_path(@response))
        return false
      end
    end

    true
  end
end
