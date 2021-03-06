require 'rails_helper'

RSpec.describe 'Admin: Page Sections', type: :request do
  before :each do
    admin = create :page_admin
    sign_in admin
  end

  describe 'GET /admin/pages/sections' do
    it 'redirects to the combined pages+sections list' do
      get page_sections_path

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.index.title' ).titlecase
    end
  end

  describe 'GET /admin/pages/section/new' do
    it 'loads the form to add a new section' do
      get new_page_section_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.sections.new.title' ).titlecase
    end
  end

  describe 'POST /admin/pages/section/new' do
    it 'fails when the form is submitted without all the details' do
      post create_page_section_path, params: {
        'page_section[title]': 'Test'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.sections.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.pages.sections.create.failure' )
    end

    it 'fails if top-level section slug collides with a controller namespace' do
      post create_page_section_path, params: {
        'page_section[name]': 'Test',
        'page_section[title]': 'Test',
        'page_section[slug]': 'profile'
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.sections.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.pages.sections.create.failure' )
    end

    it 'adds a new section when the form is submitted' do
      post create_page_section_path, params: {
        'page_section[name]': 'Test',
        'page_section[title]': 'Test',
        'page_section[slug]': 'test'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_page_section_path( PageSection.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.pages.sections.create.success' )
    end
  end

  describe 'GET /admin/pages/section/:id' do
    it 'loads the form to edit an existing section' do
      section = create :page_section

      get edit_page_section_path( section )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.sections.edit.title' ).titlecase
    end
  end

  describe 'POST /admin/pages/section/:id' do
    it 'fails to update the section when submitted without all the details' do
      section = create :page_section

      put page_section_path( section ), params: {
        'page_section[name]': nil
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.pages.sections.update.failure' )
    end

    it 'updates the section when the form is submitted' do
      section = create :page_section

      put page_section_path( section ), params: {
        'page_section[name]': 'Updated by test'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_page_section_path( section )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.sections.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.pages.sections.update.success' )
      expect( response.body ).to include 'Updated by test'
    end
  end

  describe 'DELETE /admin/pages/section/delete/:id' do
    it 'deletes the specified section' do
      s1 = create :page_section
      s2 = create :page_section
      s3 = create :page_section

      delete page_section_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to pages_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.pages.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.pages.sections.destroy.success' )
      expect( response.body ).to     have_css 'td', text: s1.name
      expect( response.body ).not_to have_css 'td', text: s2.name
      expect( response.body ).to     have_css 'td', text: s3.name
    end

    it 'fails gracefully when attempting to delete a non-existent section' do
      delete page_section_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to pages_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.pages.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.pages.sections.destroy.failure' )
    end
  end
end
