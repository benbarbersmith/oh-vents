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

  def page_header(name, heading_class = nil, subheading = nil)
      content_tag(:div, content_tag(:h1, (name + (subheading.nil? ? "" : content_tag(:small, subheading))).html_safe, :class => heading_class), :class => "page-header")
  end

  def signin_path(provider)
    "/auth/#{provider.to_s}"
  end

  def greeting
    if self.current_user.nil? == false
      link_to("#{self.current_user.screen_name}", events_path)
    end
  end    

  def in_or_out
    if self.current_user.nil? == false
      link_to "Sign out", signout_path
    else
      link_to "Sign in with Twitter",  signin_path(:twitter)
    end
  end

  def flash_box(i)
     alerts = {:alert => "alert-error", :notice=> " ", :success => "alert-success"}
     return alerts[i]
  end

  def deny_access
    redirect_to signin_path(:twitter), :notice => "You must be signed in to continue."
  end

  def current_user?(user)
    user.id == session[:user_id] 
  end

  # https://gist.github.com/1205828
  # Based on https://gist.github.com/1182136
  class BootstrapLinkRenderer < ::WillPaginate::ViewHelpers::LinkRenderer
    protected
 
    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end
 
    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
    end
 
    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end
 
    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end
 
  def page_navigation_links(pages)
    will_paginate(pages, :class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
  end

end
