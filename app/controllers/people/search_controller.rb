# frozen_string_literal: true

class People::SearchController < CrudController
    include ParamConverters
  
    self.permitted_attrs = []
  
    def entries
      if (params[:searched_string].blank?)
        Person.all
      else
        searched_name = params[:searched_string].downcase
  
        Person.all.where('LOWER(name) LIKE ?', "%#{searched_name}%")
      end
    end
  end
  