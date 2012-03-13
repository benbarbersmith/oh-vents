module PagesHelper

  def hero
    if @hero then
      render 'layouts/hero'
    end
  end

end
