class TasksController < ApplicationController
  before_action :set_task, only: %i[show index_responses update destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    class_groups = ClassGroup.where(user_id: params[:user_id])
    @tasks = Task.where(class_group_id: class_groups)
  end

  def index_responses
    @responses_task = @task.responses
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

  # GET /tasks/1/edit
  # def edit; end

  # POST /tasks
  # POST /tasks.json
  def create
    puts 'ENTROU NO CREATE'
    @task = Task.new(task_params)
    @task.status = 0

    puts @task

    if @task.save
      flash[:notice] = 'Tarefa criada com sucesso!'
      redirect_to tasks_path
    else
      #flash[:notice] = 'Erro ao criar tarefa.'
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if @task.update(task_params)
      flash[:notice] = 'Tarefa atualizada com sucesso!'
      redirect_to tasks_path
    else
      renderiza :show
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
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
end
