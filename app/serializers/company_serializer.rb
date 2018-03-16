class CompanySerializer < ApplicationSerializer
  attributes :id, :name, :location, :web, :email, :phone, :partnermanager, :contact_person, :email_contact_person, :phone_contact_person, :crm, :level, :number_MA_total, :number_MA_dev, :number_MA_sys_mid, :number_MA_PL, :number_MA_UX
end
