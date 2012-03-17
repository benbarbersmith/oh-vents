class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    unless @auth = Authorization.find_from_hash(auth)
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authorization.create_from_hash(auth, current_user)
      new = true
    end
    # Log the authorizing user in.
    session[:user_id] = @auth.user.id
    notice = "You've been signed in as #{self.current_user.screen_name}. "
    notice += (new ? "Nice to meet you!" : "Welcome back!")
    redirect_to root_url, :flash => {:success => notice}
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => "You've been signed out. Bye!"
  end
  
  def failure
    redirect_to root_url, :alert => "Something went wrong at the other end during sign in. Sorry!"
  end

end
