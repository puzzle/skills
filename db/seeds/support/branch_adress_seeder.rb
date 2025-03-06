# encoding: utf-8
class BranchAdressSeeder
  def seed_branch_adresses(branch_short_names, branch_adress_informations, branch_adress_default_branch_adress)
    branch_short_names.each_with_index do |branch_short_name, index|
      seed_branch_adress(branch_short_name, branch_adress_informations[index], branch_adress_default_branch_adress[index])
    end
  end

  private

  def seed_branch_adress(branch_short_name, adress_information, branch_adress_default_branch_adress)
    BranchAdress.seed_once(:adress_information) do |b|
      b.short_name = branch_short_name
      b.adress_information = adress_information
      b.country = 'CH'
      b.default_branch_adress = branch_adress_default_branch_adress
    end
  end
end