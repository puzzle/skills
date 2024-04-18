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

  def query_params
    skill_ids = map_array_to_query("skill_id")
    levels = map_array_to_query("level")
    interests = map_hash_to_query("interest")
    return "" if skill_ids.nil?
    (skill_ids + levels + interests).join("&")
  end

  def map_array_to_query(query_name)
    if params["#{query_name}"].present?
      params["#{query_name}"].map do |skill|
        "#{query_name}[]=#{skill}"
      end
    end
  end

  def map_hash_to_query(query_name)
    if params["#{query_name}"].present?
      params["#{query_name}"].values.map.with_index do |skill, index|
        "#{query_name}[#{index}]=#{skill}"
      end
    end
  end
end
