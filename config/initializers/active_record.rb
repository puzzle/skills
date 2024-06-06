class ActiveRecord::Base
  def destroyable?
    self.class.reflect_on_all_associations.all? do |assoc|
      [
        %i[restrict_with_error restrict_with_exception].exclude?(assoc.options[:dependent]),
        (assoc.macro == :has_one && send(assoc.name).nil?),
        (assoc.macro == :has_many && send(assoc.name).empty?)
      ].any?
    end
  end
end
