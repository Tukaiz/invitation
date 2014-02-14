class Invitation::InvitationsController < ApplicationController
  include AuthenticationLogger
  include AuthenticateAndAuthorize

  def edit
    @invitation = Invitation::InvitationPasswordForm.new(params)
  end

  def update
    @invitation = Invitation::InvitationPasswordForm.new(params[:invitation_password_form])
    # updating the users invitation with password
    # returns email address of user
    if email = @invitation.update
      if authenticate_and_authorize(email, @invitation.password).
        access_permitted?
        log_login
        redirect_back('You are now logged in.')
      else
        flash[:error] = "Something went wrong.  Please contact an administrator."
        redirect_to main_app.root_path
      end
    else
      render action: :edit
    end
  end

end
