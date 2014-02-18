class Invitation::InvitationsController < ApplicationController

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
      redirect_to invitation.new_invitation_path
    else
      respond_with(@invitation)
    end
  end

  def edit
    @invitation = Invitation::InvitationPasswordForm.new(params)
  end

  def update
    @invitation = Invitation::InvitationPasswordForm.new(params[:invitation_password_form])
    # updating the users invitation with password
    # returns email address of user
    if @invitation.update
      flash[:notice] = "Your account has been created!  Please Login."
      redirect_to main_app.root_path
    else
      render action: :edit
    end
  end

end
