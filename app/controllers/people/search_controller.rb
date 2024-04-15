# frozen_string_literal: true

class People::SearchController < CrudController
    include ParamConverters
  
    self.permitted_attrs = []
  
    def entries
      return [] if params[:searched_string].blank?

      searched_name = params[:searched_string].downcase
      
      Person.all.where('LOWER(name) LIKE ?', "%#{searched_name}%")
    end
    
  end
  