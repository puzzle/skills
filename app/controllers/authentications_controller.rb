require 'LdapTools'

class AuthenticationsController < ApplicationController
  skip_before_action :authorize
  
  def sign_in
    username = params[:username]
    password = params[:password]

    return render status: :unauthorized unless username.present? && password.present?
    
    ldap_uid = LdapTools.uid_by_username(username)
    return render status: :unauthorized if ldap_uid.nil?
    
    user = User.create_or_find(ldap_uid)
    
    return render json: { error: 'user locked' }, status: :unauthorized if user.locked?
    if LdapTools.valid_user?(username, password)
      user.reset_failed_login_attempts
      return render json: user 
    end

    user.update_failed_login_attempts
    render status: :unauthorized
  end
end
