class ClassGroupsController < ApplicationController
  before_action :set_class_group, only: %i[show new_user edit update destroy]

  # GET /class_groups
  # GET /class_groups.json
  def index
    @class_groups = ClassGroup.where(user_id: params[:id])
  end

  # GET /class_groups/1
  # GET /class_groups/1.json
  def show; end

  # GET /class_groups/new
  def new
    @class_group = ClassGroup.new
  end

  # POST /class_groups
  # POST /class_groups.json
  def create
    @class_group = ClassGroup.new(class_group_params)

    unless valid_group?
      redirect_to new_class_group_path
      return
    end

    @class_group.active = true
    @class_group.user_id = session[:user_id] # Verificar sobre passagem de id do user na rota

    if @class_group.save
      flash[:notice] = 'Turma cadastrada com sucesso!'
      redirect_to admin_classes_path(current_user)
    else
      flash[:notice] = 'Erro ao cadastrar tarefa.'
      render :new
    end
  end

  # DELETE /class_groups/1
  # DELETE /class_groups/1.json
  def destroy
    return unless remove_associates
    return unless remove_tasks
    return unless @class_group.destroy
    flash[:notice] = 'Turma removida com sucesso!'
    redirect_to admin_classes_path(current_user)
  end

  def new_user; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_class_group
    @class_group = ClassGroup.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def class_group_params
    params.require(:class_group).permit(:responsible, :discipline, :class_code, :active, :expiration_date)
  end

  def remove_associates
    @class_group.tasks.each do |task|
      Response.destroy_by(task_id: task.id)
    end

    @class_group.users.clear
  end

  def remove_tasks
    @class_group.tasks.destroy_all
  end

  def valid_group?
    unless @class_group.discipline.present? || @class_group.class_code.present?
      flash[:notice] = "Todos os campos devem ser preenchidos."
      return false
    end

    if @class_group.expiration_date < Date.today
      flash[:notice] = 'Data Inválida.'
      return false
    end

    group_equal = ClassGroup.find_by(class_code: @class_group.class_code)
    if !group_equal.nil? && group_equal.active
      flash[:notice] = 'Já existe uma turma ativa com esse código.'
      return false
    end

    true
  end
end
