# Admin controller for CMS-controlled 'brochure' pages
class Admin::PagesController < AdminController
  def index
    # List all pages
    @tl_pages = Page.top_level_pages
    @tl_sections = PageSection.top_level_sections

    @tl_hidden_pages = Page.top_level_hidden_pages
    @there_are_hidden_pages = Page.are_there_any_hidden_pages?
  end

  def new
    # Add a new page
  end

  def create
    # Save new page details
    @page = Page.new( page_params )

    if @page.save
      flash[ :notice ] = 'New page created'
      redirect_to action: 'edit', id: @page.id
    else
      flash.now[ :alert ] = 'Failed to create new page'
      render action: 'new'
    end
  end

  def page_params
    params.require( :page ).permit(
      :name, :description, :title, :slug,
      :template_id, :section_id, :sort_order, :hidden
    )
  end

  def edit
    # Edit a page
    @page = Page.find( params[:id] )
  end

  def update
    # Save edited page details
    @page = Page.find( params[:id] )

    if @page.update!( page_params )
      flash.now[ :notice ] = 'Page details updated'
    else
      flash.now[ :alert  ] = 'Failed to update page details'
    end

    render :edit
  end
end