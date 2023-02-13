# encoding: utf-8
class BranchAdressSeeder
  def seed_branch_adresses(branch_short_names, branch_adress_informations)
    branch_short_names.each_with_index do |branch_short_name, index|
      seed_branch_adress(branch_short_name, branch_adress_informations[index.to_i])
    end
  end

  private

  def seed_branch_adress(branch_short_name, adress_information)
    BranchAdress.seed_once(:adress_information) do |b|
      b.short_name = branch_short_name.to_s
      b.adress_information = adress_information.to_s
      b.country = 'CH'
    end
  end
end