# frozen_string_literal: true
module RoleFormHelper
  # This method creates a link with `data-id` `data-fields` attributes. These attributes are used 
  # to create new instances of the nested fields through Javascript.
  def link_to_add_role(name, form, association)
    # Takes an object and creates a new instance of its associated model
    new_role = form.object.send(association).klass.new
    # Saves the unique ID of the object into a variable.
    # This is needed to ensure the key of the associated array is unique. This makes parsing the
    # content in the `data-fields` attribute easier through Javascript.
    id = new_role.object_id
    # child_index` is used to ensure the key of the associated array is unique, and that it matched
    # the value in the `data-id` attribute.
    fields = form.fields_for(association, new_role, child_index: id) do |builder|
      render("#{association.to_s.singularize}_fields", person_role: builder)
    end


    # This renders a simple link, but passes information into `data` attributes.
    # This info can be named anything we want, but in this case
    # we chose `data-id:` and `data-fields:`.
    # We use `gsub("\n", "")` to remove anywhite space from the rendered partial.
    # The `id:` value needs to match the value used in `child_index: id`.
    link_to(name, '#', class: 'add_fields', data: { id: id, fields: fields.gsub("\n", '') })
  end
end
