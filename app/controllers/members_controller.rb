class MembersController < AuthorizedController

    def index
        @members = @tenant.members
    end

    def invite
        email = params[:email]
        return redirect_to tenant_members_path(@tenant), alert:"Email is required" if email.blank?
        user = User.find_by(email:) || User.invite!({email:}, current_user)
        return redirect_to tenant_members_path(@tenant), alert:"User not found" if !user.valid?
        user.members.find_or_create_by(tenant: @tenant, roles:{admin: false, editor: true})
        redirect_to tenant_members_path(@tenant), notice:"#{email} invited successfully"
    end


end
