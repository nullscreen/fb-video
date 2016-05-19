require 'spec_helper'

describe 'Videos' do
  describe '.where' do
    context 'given one correct video id and one field' do
      let(:videos) do
        Funky::Videos.new.where ids:    '1042790765791228',
                                fields: 'likes.summary(true)'
      end

      it 'should return one Video object in an Array' do
        expect(videos).to be_instance_of(Array)
        expect(videos.first).to be_instance_of(Funky::Video)
      end
    end

    context 'given multiple video ids and one field' do
      let(:videos) do
        Funky::Videos.new.where ids: ['1042790765791228', '817186021719592'],
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
end
