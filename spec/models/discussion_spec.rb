# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discussion, type: :model do
  context 'factory' do
    it 'can create a discussion' do
      news_post  = create :news_post
      discussion = create :discussion, resource: news_post

      expect( Discussion.last ).to eq discussion
    end
  end

  context 'methods' do
    context '.recently_active' do
      before :each do
        @less_active_post = create :news_post
        @active_this_week = create :news_post
        @active_last_week = create :news_post

        create :discussion, resource: @less_active_post, comment_count: rand(5)
        create :discussion, resource: @active_this_week, comment_count: 5
        create :discussion, resource: @active_last_week, comment_count: 6, comments_posted_at: 8.days.ago
      end

      describe 'without params' do
        it 'fetches the most active discussions from the last week, most active first' do
          active, counts = Discussion.recently_active

          expect( active.length ).to eq 2
          expect( active.find( counts.first.first ).resource ).to eq @active_this_week
        end
      end

      describe 'with params' do
        it 'fetches the most active discussions from the specified timespan' do
          active, counts = Discussion.recently_active( days: 14 )

          expect( active.length ).to eq 3
          expect( active.find( counts.first.first ).resource ).to eq @active_last_week
        end
      end
    end
  end
end
