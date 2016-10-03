require 'spec_helper'
require 'videos/shared/examples'

describe 'Video' do
  let(:existing_video_id) { '1042790765791228' }
  let(:unknown_video_id) { 'does-not-exist' }
  let(:another_video_id) { '903078593095780' }

  describe '.where(id: video_ids)' do
    let(:videos) { Funky::Video.where(id: video_ids) }

    context 'given one existing video ID was passed' do
      let(:video_ids) {existing_video_id}
      let(:video) {videos.first}

      it { expect(video.id).to be_a(String) }
      it { expect(video.created_time).to be_a(DateTime) }
      it { expect(video.description).to be_a(String) }
      it { expect(video.length).to be_a(Float) }
      it { expect(video.picture).to be_a(String)}
      it { expect(video.page_name).to be_a(String) }
    end

    context 'given one unknown video ID was passed' do
      let(:video_ids) {unknown_video_id}

      it { expect(videos).to be_empty }
    end

    context 'given multiple existing video IDs were passed' do
      let(:video_ids) { [existing_video_id, another_video_id] }
      specify 'returns one video for each id, in the same order provided' do
        expect(videos.map &:id).to eq(video_ids)
      end
    end

    context 'given an unknown video id passed with an existing video id' do
      let(:video_ids) { [existing_video_id, unknown_video_id] }

      specify 'returns only the existing videos' do
        expect(videos.map &:id).to eq([existing_video_id])
      end
    end

    context 'given a Faraday::ConnectionFailed error' do
      let(:video_ids) { [existing_video_id, another_video_id] }
      let(:socket_error) { SocketError.new }

      before { expect(Net::HTTP).to(receive(:start).and_raise socket_error) }

      it { expect { videos }.to raise_error(Funky::ConnectionError) }
    end
  end

  describe '.find(video_id)' do
    let(:video) {Funky::Video.find(video_id)}

    context 'given an existing video ID was passed' do
      let(:video_id) { existing_video_id }

      include_examples 'check id and counters'
    end

    context 'given a non-existing video ID was passed' do
      let(:video_id) { unknown_video_id }

      include_examples 'non-existing video'
    end

    context 'given a video ID with the cumulative views was passed' do
      let(:video_id) { '10153924745896633' }

      include_examples 'cumulative views'
    end

    context 'given server errors' do
      let(:video_id) { existing_video_id }

      include_examples 'server errors'
    end
  end

  describe '.find_by_url!(url)' do
    let(:video) {Funky::Video.find_by_url! url}

    context "given an existing video url" do
      let(:video_id) { '965037490222386' }
      let(:url) { "facebook.com/videos.php?v=#{video_id}" }

      include_examples 'check id and counters'
    end


    context 'given a non-existing video url was passed' do
      let(:url) { 'https://www.facebook.com/video.php?v=doesnotexist'}

      include_examples 'non-existing video'
    end

    context 'given a video url with cumulative views was passed' do
      let(:url) { 'https://www.facebook.com/video.php?v=10153924745896633' }

      include_examples 'cumulative views'
    end

    context 'given server errors' do
      let(:url) { 'https://www.facebook.com/video.php?v=1559182744389118' }

      include_examples 'server errors'
    end
  end
end
