module RoleFormHelper
  def link_to_add_role(name, form, association)
    new_role = form.object.send(association).klass.new
    id = new_role.object_id
    fields = form.fields_for(association, new_role, child_index: id) do |builder|
      render("#{association.to_s.singularize}_fields", person_role: builder)
    end
    link_to(
      name,
      '#',
      class: 'add_fields',
      data: {
        id: id,
        fields: fields.gsub("\n", '')
      }
    )
  end
end