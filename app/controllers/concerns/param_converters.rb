# frozen_string_literal: true

module ParamConverters

  private

  def true?(value)
    %w[1 yes true].include?(value.to_s.downcase)
  end

  def false?(value)
    %w[0 no false].include?(value.to_s.downcase)
  end

  def nil_param?(value)
    value == 'null' ? nil : value
  end

  def search_skill(row_id)
    params[:skill_id].present? ? params[:skill_id][row_id].to_i : nil
  end

  def search_level(row_id)
    if params[:level].present?
      params[:level][row_id].present? ? params[:level][row_id].to_i : 1
    else
      1
    end
  end

  def search_interest(row_id)
    if params[:interest].present?
      params[:interest].values[row_id].present? ? params[:interest].values[row_id].to_i : 1
    else
      1
    end
  end
end
