class ActiveRecord::Base
  def destroyable?
    self.class.reflect_on_all_associations.all? do |assoc|
      [
        %i[restrict_with_error restrict_with_exception].exclude?(assoc.options[:dependent]),
        (assoc.macro == :has_one && send(assoc.name).nil?),
        (assoc.macro == :has_many && send(assoc.name).empty?),
        (assoc.macro == :has_and_belongs_to_many && send(assoc.name).empty?)
      ].any?
    end
  end

  def human_attribute_name(*args)
    attr_name = args.first
    attr = self.send(attr_name)
    args[1] ||= {count: attr.length} if attr.respond_to?(:length)
    self.class.human_attribute_name(*args)
  end
end
