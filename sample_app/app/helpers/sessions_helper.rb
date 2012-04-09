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
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    #cookies.delete(:remember_token)
    session[:current_user_id] = nil
    self.current_user = nil
  end  
  
  def url_for(options = nil)
    if Hash === options
      options[:protocol] ||= 'http'
    end
    super(options)
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end