class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: [ :edit, :update, :destroy ]

  # GET /admin/products
  def index
    @products = Product.all
  end

  # GET /admin/products/new
  def new
    @product = Product.new
  end

  # POST /admin/products
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Product was successfully created."
    else
      render :new
    end
  end

  # GET /admin/products/:id/edit
  def edit
  end

  # PATCH/PUT /admin/products/:id
  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Product was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /admin/products/:id
  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Product was successfully deleted."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :current_price, :stock_quantity)
  end
end
