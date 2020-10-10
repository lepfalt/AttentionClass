class TasksController < ApplicationController
  before_action :set_task, only: %i[show index_responses update destroy cancel remove_ajusted]

  # GET /tasks
  # GET /tasks.json
  def index
    class_groups = ClassGroup.where(user_id: params[:user_id])
    @tasks = Task.where(class_group_id: class_groups)
    check_completed_tasks
  end

  def index_responses
    @responses_task = @task.responses.where(status: 2)
  end

  def show_response
    @response_task = Response.find_by(id: params[:id])
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.status = 0
    @task.active = true

    unless valid_task?
      redirect_to new_task_path
      return
    end

    if @task.save
      flash[:notice] = 'Tarefa criada com sucesso!'
      redirect_to tasks_board_path(current_user.id)
    else
      flash[:notice] = 'Erro ao criar tarefa.'
      redirect_to new_task_path
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update    
    unless valid_task?
      redirect_to task_path(@task)
      return
    end

    if Date.parse(task_params[:expiration_date]) < @task.expiration_date
      flash[:notice] = "A tarefa não pode ser antecipada."
      redirect_to task_path(@task)
      return
    end

    if @task.update(task_params)
      if @task.progress?
        generate_responses
      end

      flash[:notice] = 'Tarefa atualizada com sucesso!'
      redirect_to tasks_board_path(current_user.id)
    else
      renderiza :show
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    flash[:notice] = 'Tarefa excluída com sucesso!'
    redirect_to tasks_board_path(current_user.id)
  end

  def cancel
    @task.active = false
    if @task.save
      @task.responses.each do |response|
        response.active = false
        puts 'erro ao inativar response' unless response.save
      end

      flash[:notice] = 'Tarefa excluída com sucesso!'
      redirect_to tasks_board_path(current_user.id)
    else
      flash[:notice] =  "Erro ao cancelar task" # Criar Error
    end
  end

  def remove_ajusted
    @task.active = false
    if @task.save
      flash[:notice] = 'Tarefa excluída com sucesso!'
      redirect_to tasks_board_path(current_user.id)
    else
      flash[:notice] = "Erro ao remover task" # Criar Error
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :status, :expiration_date, :class_group_id)
  end

  def generate_responses
    users_group = @task.class_group.users
    users_group.each do |user|
      response = Response.find_or_initialize_by(user_id: user.id, task_id: @task.id, status: 0, active: true)
      puts "Error na criacao de response: ", response.errors unless response.save
    end
  end

  def check_completed_tasks
    @tasks.each do |task|
      if task.progress? && task.expiration_date < Date.today
        task.status = 2
        puts 'Erro ao concluir tarefa automática', task.errors unless task.save
      end
    end
  end

  def valid_task?
    field = nil
    if !@task.title.present?
      field = "Título inválido"
    elsif !@task.expiration_date.present? || @task.expiration_date < Date.today
      field = "Data Limite inválida"
    elsif @task.expiration_date > @task.class_group.expiration_date
      field = "Data Limite inválida. A data deve ser compreendida no período vigente da turma."
    elsif !@task.class_group_id.present?
      field = "Turma inválida"
    elsif !@task.description.present?
      field = "Descrição inválida"
    else
      return true
    end

    flash[:notice] = field
    false
  end
end
