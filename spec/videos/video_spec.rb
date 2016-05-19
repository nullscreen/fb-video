require 'spec_helper'

describe 'Video' do
  describe 'self.where' do
    context 'given one correct video id and one field' do
      let(:videos) do
        Funky::Video.where ids:    '1042790765791228',
                           fields: 'likes.summary(true)'
      end

      it 'should return one Video object in an Array' do
        expect(videos).to be_instance_of(Array)
        expect(videos.first).to be_instance_of(Funky::Video)
      end
    end

    context 'given multiple video ids and one field' do
      let(:videos) do
        Funky::Video.where ids:    ['1042790765791228', '817186021719592'],
                           fields: 'likes.summary(true)'
      end

      it 'should return multiple Video objects in an Array' do
        expect(videos).to be_instance_of(Array)
        expect(videos.count).to eq(2)
        expect(videos[0]).to be_instance_of(Funky::Video)
        expect(videos[1]).to be_instance_of(Funky::Video)
      end
    end
  end

  describe '.like_count' do
    context 'given expected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("likes"=>{"summary"=>{"total_count"=>761}})
      end

      it 'should return an Integer' do
        expect(video.like_count).to eq(761)
      end
    end

    context 'given unexpected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("incorrect"=>{"summary"=>{"total_count"=>761}})
      end

      it 'should return nil' do
        expect(video.like_count).to be(nil)
      end
    end
  end

  describe '.comment_count' do
    context 'given expected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("comments"=>{"summary"=>{"total_count"=>1234}})
      end

      it 'should return an Integer' do
        expect(video.comment_count).to eq(1234)
      end
    end

    context 'given unexpected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("incorrect"=>{"summary"=>{"total_count"=>1234}})
      end

      it 'should return nil' do
        expect(video.comment_count).to be(nil)
      end
    end
  end

  describe '.share_count' do
    context 'given expected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("id" => "1042790765791228")
      end

      it 'should return an Integer' do
        expect(video.share_count.is_a? Integer).to be(true)
      end
    end

    context 'given unexpected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("id" => "doesnotexist")
      end

      it 'should return nil' do
        expect(video.share_count).to be(nil)
      end
    end
  end

  describe '.view_count' do
    context 'given expected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("id" => "1042790765791228")
      end

      it 'should return an Integer' do
        expect(video.view_count.is_a? Integer).to be(true)
      end
    end

    context 'given unexpected data format is retrieved from Facebook' do
      let(:video) do
        Funky::Video.new("id" => "doesnotexist")
      end

      it 'should return nil' do
        expect(video.view_count).to be(nil)
      end
    end
  end
end
