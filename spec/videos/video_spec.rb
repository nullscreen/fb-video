require 'spec_helper'

describe 'Video' do
  let(:existing_video_id) { '1042790765791228' }
  let(:unknown_video_id) { 'does-not-exist' }
  let(:another_video_id) { '1042790765791228' }

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
  end

  describe '.find(video_id)' do
    let(:video) {Funky::Video.find(video_id)}

    context 'given an existing video ID was passed' do
      let(:video_id) { existing_video_id }

      it { expect(video.id).to be_a(String) }
      it { expect(video.like_count).to be_an(Integer) }
      it { expect(video.comment_count).to be_an(Integer) }
      it { expect(video.share_count).to be_an(Integer) }
      it { expect(video.view_count).to be_an(Integer) }
    end

    context 'given a non-existing video ID was passed' do
      let(:video_id) { unknown_video_id }

      it { expect {video}.to raise_error(Funky::ContentNotFound) }
    end
  end
end
