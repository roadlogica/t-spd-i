class UnAuthenticatedApplicationController < ActionController::Base
  include TSPDError
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale, :set_buttons

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  #
  #   Make titlebar from i18n labels
  #
  def make_i18b_titlebar(title, subtitle)
    @title = t(title) + ' - ' + t(subtitle)
  end

  def set_submenu(type)
    @submenu = type
    make_i18b_titlebar 'mnu_receive', "submenu_#{type}"
  end

  def get_current_period
    return Date.today.strftime("%Y%m")
  end

  private

  def set_buttons
    @buttons = []
  end

end

class ApplicationController < UnAuthenticatedApplicationController
  before_filter :authenticate_user! #, :except => [:index, :api]
end