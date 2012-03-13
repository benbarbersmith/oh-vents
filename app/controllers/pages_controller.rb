class PagesController < ApplicationController
  def home
    @title = "Home"
    @hero  =  true
  end

  def contact
    @title = "Contact"
  end

  def help
    @title = "Help"
  end

end
