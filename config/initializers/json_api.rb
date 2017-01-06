ActiveSupport.on_load(:action_controller) do
  require 'active_model_serializers/register_jsonapi_renderer'
  ActiveModelSerializers.config.key_transform = :underscore
end
