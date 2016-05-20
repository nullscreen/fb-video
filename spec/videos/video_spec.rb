require 'spec_helper'

describe 'Video' do
  describe '.where(ids: video_id)' do
    let(:video) do
      Funky::Video.where(ids: '1042790765791228').first
    end

    context 'given an existing video ID was passed' do
      describe '.id' do
        it { expect(video.id).to be_a(String) }
      end

      describe '.like_count' do
        it { expect(video.like_count).to be_a(Fixnum) }
      end

      describe '.comment_count' do
        it { expect(video.comment_count).to be_a(Fixnum) }
      end

      describe '.share_count' do
        it { expect(video.share_count).to be_a(Fixnum) }
      end

      describe '.view_count' do
        it { expect(video.view_count).to be_a(Fixnum) }
      end

      describe '.created_time' do
        it { expect(video.created_time).to be_a(DateTime) }
      end

      describe '.description' do
        it { expect(video.description).to be_a(String) }
      end

      describe '.length' do
        it { expect(video.length).to be_a(Float) }
      end
    end
  end

  describe '.where(ids: multiple_video_ids)' do
    let(:multiple_video_ids) do
      ['1042790765791228', '10154439119663508',
        '817186021719592','827340920704102', '830518890386305',
        '903078593095780', '1042754339128204', '1041643712572600',
        '1042056582531313','1042669312451336']
    end
    let(:videos) { Funky::Video.where(ids: multiple_video_ids) }

    context 'given multiple existing video IDs were passed' do
      specify 'returns one video for each id, in the same order provided' do
        expect(videos.map &:id).to eq(multiple_video_ids)
      end
    end
  end
end
