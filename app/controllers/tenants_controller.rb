class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[ show edit update destroy ]
  before_action :authorize_member, only: %i[ show edit update destroy ]

  # GET /tenants or /tenants.json
  def index
    @tenants = current_user.tenants
  end

  # GET /tenants/1 or /tenants/1.json
  def show
    redirect_to root_path, alert:"You are not a member." unless @tenant.members.include?(current_user)
  end

  # GET /tenants/new
  def new
    @tenant = Tenant.new
  end

  # GET /tenants/1/edit
  def edit
  end

  # POST /tenants or /tenants.json
  def create
    @tenant = Tenant.new(tenant_params)

    respond_to do |format|
      if @tenant.save
        @tenant.members.create(user: current_user, roles: { admin: true })
        format.html { redirect_to @tenant, notice: "Tenant was successfully created." }
        format.json { render :show, status: :created, location: @tenant }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @tenant.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /tenants/1 or /tenants/1.json
  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to @tenant, notice: "Tenant was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @tenant }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @tenant.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /tenants/1 or /tenants/1.json
  def destroy
    @tenant.destroy!

    respond_to do |format|
      format.html { redirect_to tenants_path, notice: "Tenant was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params.expect(:id))
    end

    def authorize_member
      redirect_to root_path, alert:"You are not a member." unless @tenant.members.include?(current_user)
    end

    # Only allow a list of trusted parameters through.
    def tenant_params
      params.expect(tenant: [ :name ])
    end
end
