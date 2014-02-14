class Invitation::Admin::InvitationsController < Admin::BaseController
  respond_to :html

  def new
    @invitation = Invitation::InvitationForm.new
  end

  def create
    args = {
      email: params[:invitation_form][:email],
      current_site_name: current_site.name,
      accept_invitation_url: edit_invitation_url
    }
    @invitation = Invitation::InvitationForm.new(args)
    if @invitation.save
      flash[:notice] = "Invitation sent!"
      redirect_to invitation.new_admin_invitation_path
    else
      respond_with(@invitation)
    end
  end

end
