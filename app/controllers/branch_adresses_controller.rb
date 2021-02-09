class BranchAdressesController < CrudController

  private

  def fetch_entries
    BranchAdress.all
  end
end