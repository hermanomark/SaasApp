class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!, :only => [ :index ]

  # set current tenant by hand by using session tenant id, very similar on how we handle the session in Alphablog
  def index
    if current_user
      if session[:tenant_id]
        Tenant.set_current_tenant session[:tenant_id]
      else
        Tenant.set_current_tenant current_user.tenants.first
      end
    end

    @tenant = Tenant.current_tenant
    params[:tenant_id] = @tenant.id
  end
end
