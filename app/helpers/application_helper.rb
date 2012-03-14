module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "oh!vents"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def signin_path(provider)
    "/auth/#{provider.to_s}"
  end

  def greeting
    if self.current_user.nil? == false
      link_to("#{self.current_user.screen_name}", '#')
    end
  end    

  def in_or_out
    if self.current_user.nil? == false
      link_to "Sign out", signout_path
    else
      link_to "Sign in with Twitter",  signin_path(:twitter)
    end
  end
end
