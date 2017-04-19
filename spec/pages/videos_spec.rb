require 'spec_helper'
require 'pages/shared/examples'

describe 'Page' do
  let(:fullscreen_page_id) { 'FullscreenInc' }
  let(:nextflix_page_id) { 'NetflixUS' }

  describe '#videos' do
    let(:page) { Funky::Page.find(page_id) }
    let(:videos) { page.videos }

    context 'given an existing page ID was passed' do
      let(:page_id) { fullscreen_page_id }

      specify 'returns a list of videos' do
        video = videos.first

        expect(video).to be_a Funky::Video
        expect(video.title).to be_a String
        expect(video.count_likes).to be_a Integer
        expect(video.count_comments).to be_a Integer
        expect(video.count_reactions).to be_a Integer
      end

      specify 'returns more than one page of videos' do
        expect(videos.count).to be > 100
      end

      # NOTE: This test fails if we strictly follow the Facebook
      # documentation of fetching pages with token-based pagination.
      specify 'includes the oldest video of the page' do
        expect(videos.map {|v| v.id}).to include '621484897895222'
      end
    end

    context 'given a page with hundreds of videos' do
      let(:page_id) { nextflix_page_id }

      # NOTE: This test fails if we only strictly followed the Facebook
      # documentation of fetching pages with timestmap-based pagination.
      specify 'includes the oldest video of the page' do
        expect(videos.map {|v| v.id}).to include '68196585394'
      end
    end
  end
end
