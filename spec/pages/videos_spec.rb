require 'spec_helper'
require 'pages/shared/examples'

describe 'Page' do
  let(:fullscreen_page_id) { 'FullscreenInc' }
  let(:nextflix_page_id) { 'NetflixUS' }
  let(:nbc_page_id) { 'NBC' }

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

    context 'given a request that raises' do
      let(:response) { Net::HTTPServerError.new nil, nil, nil }
      let(:response_body) { '{"name":"Fullscreen"}' }
      before { expect(Net::HTTP).to receive(:start).once.and_return response }
      before { allow(response).to receive(:body).and_return response_body }

      context 'a 500 Server Error' do
        let(:page_id) { fullscreen_page_id }
        let(:retry_response) { retry_response_class.new nil, nil, nil }
        before { allow(retry_response).to receive(:body).and_return response_body }
        before { expect(Net::HTTP).to receive(:start).at_least(:once).and_return retry_response }

        context 'every time' do
          let(:retry_response_class) { Net::HTTPServerError }

          it { expect{ page }.to raise_error Funky::ConnectionError }
        end

        context 'but returns a success code 2XX the second time' do
          let(:retry_response_class) { Net::HTTPOK }

          it { expect{ page }.not_to raise_error }
        end
      end
    end
  end

  describe '#videos with since option' do
    let(:page) { Funky::Page.find(page_id) }
    let(:videos) { page.videos(since: since_date) }

    context 'given an existing page ID and since date' do
      let(:page_id) { fullscreen_page_id }
      let(:since_date) { "2017-07-27" }

      specify 'returns the first video of since date as the last' do
        expect(videos.last.id).to eq('1517225178321185')
      end
    end
  end
end
