require 'spec_helper'
require 'videos/shared/examples'

describe 'Video' do
  let(:existing_video_id) { '1042790765791228' }
  let(:unknown_video_id) { 'does-not-exist' }
  let(:another_video_id) { '903078593095780' }
  let(:redirect_video_id) { '322742591438587' }
  let(:no_description_id) { '10154637916753090' }

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
      it { expect(video.page_id).to be_a(String) }
      it { expect(video.page_url).to be_a(String) }
    end

    context 'given one unknown video ID was passed' do
      let(:video_ids) {unknown_video_id}

      it { expect(videos).to be_empty }
    end

    context 'given a video with no description' do
      let(:video_ids) { no_description_id }
      let(:video) {videos.first}

      it { expect(video.description).to be_a(String) }
    end

    context 'given multiple existing video IDs were passed' do
      let(:video_ids) { [existing_video_id, another_video_id] }
      specify 'returns one video for each id, in the same order provided' do
        expect(videos.map &:id).to eq(video_ids)
      end
    end

    context 'given more than 50 video IDs were passed' do
      let(:video_ids) { %w(829511587149272 1121632767892937 827919440672156
       1386918477991126 555557277950480 1832595776971196 1210955495589682
       1650061391976374 683414781806537 1037371776384005 1066307430126652
       1659520674375232 1022145577892297 505676222973586 1127095260670463
       1412022202148557 1412022015481909 650573988425085 1714061978843414
       843052412506340 1042943289130592 827633567372165 1139796902735090
       1660396160950720 1143640149040808 1240608716011485 996943737090313
       1137883682938509 1234460389983920 499908580208836 10155088019398242
       497343333798860 1093500627383310 1060068997394294 1243680845664700
       761939050613381 615827281926831 504423163080946 1728596574061605
       1240698539307771 1788965088007488 1189959977716075 549082508609145
       501824276683006 1165897410097840 1217067938325686 1052034134843975
       1080850732004512 1259805267377415 1740224422907185 1308353619194499
       1080024992082728 623890031109174 1577453205882343 10153943799079032
       1670859479904986 650812281743938 633055470195906 557845444425867
       857653861033768 579927078853751 947283015417815 10153991171697701
       1066355780120769 10154493941382275 884061691698375 1170493716326128
       1233611580006139 1814677542081075 1711760805755429 1329912187038194
       1568990130063735 1745411419035072 1749662271957646 271133443258784
       1119610328118646 1319777108050140 667799410037949 171161249969892) }
      specify 'returns information about all of them' do
        expect(videos.count).to be > 50
      end
    end

    context 'given an unknown video id passed with an existing video id' do
      let(:video_ids) { [existing_video_id, unknown_video_id] }

      specify 'returns only the existing videos' do
        expect(videos.map &:id).to eq([existing_video_id])
      end
    end

    context 'given a connection error' do
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

    context 'given a video published by a page with a space in its username' do
      let(:video_id) { redirect_video_id }

      include_examples 'check id and counters'
    end

    context 'given an existing video ID of a video with more than 800 likes was passed' do
      let(:video_id) { existing_video_id }

      it { expect(video.like_count).to be > 800 }
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
