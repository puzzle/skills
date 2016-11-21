class UserSerializer < ActiveModel::Serializer
  attributes :id, :ldap_uid, :api_token
end
