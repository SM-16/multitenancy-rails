class AuthorizedController < ApplicationController
    before_action :set_tenant
    before_action :authorize_member
    
    private

    def authorize_member
        redirect_to root_path, alert:"You are not a member." unless @tenant.users.include?(current_user)
    end

    def set_tenant
        @tenant = Tenant.find(params[:tenant_id])
    end
end