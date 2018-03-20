class EmployeeQuantitiesController < ApplicationController
  before_action :set_employee_quantity, only: [:show, :update, :destroy]

  # GET /employee_quantities
  def index
    @employee_quantities = EmployeeQuantity.all

    render json: @employee_quantities
  end

  # GET /employee_quantities/1
  def show
    render json: @employee_quantity
  end

  # POST /employee_quantities
  def create
    @employee_quantity = EmployeeQuantity.new(employee_quantity_params)

    if @employee_quantity.save
      render json: @employee_quantity, status: :created, location: @employee_quantity
    else
      render json: @employee_quantity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employee_quantities/1
  def update
    if @employee_quantity.update(employee_quantity_params)
      render json: @employee_quantity
    else
      render json: @employee_quantity.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employee_quantities/1
  def destroy
    @employee_quantity.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_quantity
      @employee_quantity = EmployeeQuantity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def employee_quantity_params
      params.require(:employee_quantity).permit(:category, :quantity, :company_id)
    end
end
