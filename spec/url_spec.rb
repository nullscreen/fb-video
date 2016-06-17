require 'spec_helper'

describe Funky::URL do
  let(:video_id) { '965037490222386' }

  def parses(text)
    url = Funky::URL.new text
    expect(url.video_id).to eq(video_id)
  end

  it 'parses any valid URL format for a Facebook video' do
    # Possible formats
    parses "facebook.com/PAGE_NAME/videos/vb.PAGE_ID/#{video_id}"
    parses "facebook.com/PAGE_NAME/videos/vl.PAGE_ID/#{video_id}"
    parses "facebook.com/PAGE_NAME/videos/#{video_id}"
    parses "facebook.com/PAGE_ID/videos/#{video_id}"
    parses "facebook.com/video.php?v=#{video_id}"

    # Possible variants
    parses "facebook.com/PAGE_NAME/videos/vl.PAGE_ID/#{video_id}/?type=1"
    parses "facebook.com/video.php?v=#{video_id}/"
    parses "www.facebook.com/video.php?v=#{video_id}"
    parses "http://facebook.com/video.php?v=#{video_id}"
    parses "https://facebook.com/video.php?v=#{video_id}"
    parses "http://www.facebook.com/video.php?v=#{video_id}"
    parses "https://www.facebook.com/video.php?v=#{video_id}"
  end
end
