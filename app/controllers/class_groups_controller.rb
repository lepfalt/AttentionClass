class ClassGroupsController < ApplicationController
  before_action :set_class_group, only: %i[show new_user index_users edit update destroy]

  # GET /class_groups
  # GET /class_groups.json
  def index
    class_groups_user = ClassGroup.where(user_id: params[:id])
    check_class_groups_validity(class_groups_user)
    @class_groups = class_groups_user.where(active: true)
  end

  def index_users; end

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

    return unless valid_group?

    @class_group.active = true
    @class_group.user_id = session[:user_id] # Verificar sobre passagem de id do user na rota

    if @class_group.save
      handler_notice('Turma cadastrada com sucesso!', admin_classes_path(current_user))
    else
      flash[:noticeError] = 'Erro ao cadastrar tarefa.'
      render :new
    end
  end

  # DELETE /class_groups/1
  # DELETE /class_groups/1.json
  def destroy
    return unless remove_associates
    return unless remove_tasks
    return unless @class_group.destroy

    handler_notice('Turma removida com sucesso!', admin_classes_path(current_user))
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
      handler_notice_error("Todos os campos devem ser preenchidos.", new_class_group_path)
      return false
    end

    if @class_group.expiration_date < Date.today
      handler_notice_error('Data Inválida.', new_class_group_path)
      return false
    end

    group_equal = ClassGroup.find_by(class_code: @class_group.class_code)
    if !group_equal.nil? && group_equal.active
      handler_notice_error('Já existe uma turma ativa com esse código.', new_class_group_path)
      return false
    end

    true
  end

  def check_class_groups_validity(class_groups)
    class_groups.each do |group|
      if group.active && group.expiration_date < Date.today
        group.active = false
        puts 'Erro ao desativar turma' unless group.save
      end
    end
  end
end
