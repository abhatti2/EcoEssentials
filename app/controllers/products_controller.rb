class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  # GET /products or /products.json
  def index
    @categories = Category.all # Fetch all categories for the dropdown

    # Start with all products and apply search and filter logic
    @products = Product.includes(:category).search(params[:query])

    # Filter by category if `category_id` is provided
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?

    # Paginate results
    @products = @products.page(params[:page]).per(10)
  end

  # GET /products/1 or /products/1.json
  def show; end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      flash.now[:alert] = "There were errors creating the product."
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      flash.now[:alert] = "There were errors updating the product."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1 or /products.json
  def destroy
    if @product.destroy
      redirect_to products_path, notice: "Product was successfully destroyed.", status: :see_other
    else
      redirect_to products_path, alert: "Failed to delete the product.", status: :see_other
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found."
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :current_price, :stock_quantity, :category_id)
  end
end
