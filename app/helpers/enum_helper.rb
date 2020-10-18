# frozen_string_literal: true

module EnumHelper
  def options_for_enum(object, enum, remove_n_top)
    options = enums_to_translated_options_array(object.class.name, enum.to_s)
    options.pop(remove_n_top)
    options_for_select(options, object.send(enum))
  end

  def enums_to_translated_options_array(klass, enum)
    klass.classify.safe_constantize.send(enum.pluralize).map do |key, _value|
      [I18n.t("activerecord.enums.#{klass.underscore}.#{enum}.#{key}"), key]
    end
  end

  def value_enum_current(status)
    status_list = {
      'pending' => 'Pendente',
      'progress' => 'Em Andamento',
      'done' => 'Concluído',
      'ajusted' => 'Corrigido'
    }
    status_list[status]
  end
end
