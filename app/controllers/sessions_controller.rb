# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]

  layout -> { action_name == "new" ? "auth" : "account_settings" }

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to sign_in_path, alert: "Too many attempts. Try again later." }

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to account_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
    end
  end

  def destroy
    @session.destroy; redirect_to(sessions_path, notice: "That session has been logged out")
  end

  def sign_out
    Current.session.destroy
    cookies.delete(:session_token)

    redirect_to sign_in_path, notice: "You have signed out", status: :see_other
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
