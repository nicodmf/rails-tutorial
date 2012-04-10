module SessionsHelper

  def sign_in(user)
    #session :on
    session[:current_user_id] = user.id
    #cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  def current_user=(user)
    @current_user = user
  end  
  def current_user
    @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
    #@current_user ||= user_from_remember_token
  end
  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end  
  def signed_in?
    !current_user.nil?
  end  
  def sign_out
    #cookies.delete(:remember_token)
    session[:current_user_id] = nil
    self.current_user = nil
  end  
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Merci de vous identifier pour rejoindre cette page."
  end
  def deny_access_user(default=nil, notice=nil)
    session[:return_to] = request.referer || default
    redirect_back_or signin_path, notice||"Vous ne pouvez acceder a cette page"
  end  
  
  def redirect_back_or(default, notice=nil)
    if notice
      redirect_to(session[:return_to] || default, :notice=>notice)
    else
      redirect_to(session[:return_to] || default)
    end
    clear_return_to
  end
  
  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
    
end