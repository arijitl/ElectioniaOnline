class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :default_headers
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    auth=request.env["omniauth.auth"]
    render :json => auth
    return
    #@user = User.find_for_facebook_oauth(request.env["omniauth.auth"].provider, request.env["omniauth.auth"].uid, request.env["omniauth.auth"].extra.raw_info.name, request.env["omniauth.auth"].info.email, request.env["omniauth.auth"].info.image, current_user)
    @user = User.find_by_uid(request.env["omniauth.auth"].uid)

    if !User.find_by_uid(auth['uid']).nil?
      @user.display_modal = true
      @user.save
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      user = User.create(:name => request.env["omniauth.auth"].extra.raw_info.name,
                         :provider => request.env["omniauth.auth"].provider,
                         :uid => request.env["omniauth.auth"].uid,
                         :email => "fb#{Random.rand(0..99999)}@eeeeemmail.com",
                         :password => Devise.friendly_token[0,20],
                         :avatar=> open(request.env["omniauth.auth"].info.image)
      )
      session["devise.facebook_data"] = request.env["omniauth.auth"].uid
      sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
      #redirect_to new_user_registration_url
    end
  end

  def canvas_fb
    render :josn => request.env['facebook.params']
    return
  end

  def default_headers
    headers['X-Frame-Options'] = 'GOFORIT'
  end

end