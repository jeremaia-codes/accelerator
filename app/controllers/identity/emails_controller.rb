# frozen_string_literal: true

class Identity::EmailsController < ApplicationController
  layout "account_settings"

  before_action :set_user

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to_edit
    else
      render :edit, status: :unprocessable_content
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def user_params
      params.permit(:email, :password_challenge).with_defaults(password_challenge: "")
    end

    def redirect_to_edit
      if @user.email_previously_changed?
        resend_email_verification
        redirect_to edit_identity_email_path, notice: "Your email has been changed"
      else
        redirect_to edit_identity_email_path
      end
    end

    def resend_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
