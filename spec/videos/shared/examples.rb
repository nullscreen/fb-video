shared_examples 'check id and counters' do
  it { expect(video.id).to be_a(String) }
  it { expect(video.like_count).to be_an(Integer) }
  it { expect(video.comment_count).to be_an(Integer) }
  it { expect(video.share_count).to be_an(Integer) }
  it { expect(video.view_count).to be_an(Integer) }
end

shared_examples 'socket error' do
  let(:socket_error) { SocketError.new }

  before { expect(Net::HTTP).to(receive(:start).and_raise socket_error) }

  it { expect { video }.to raise_error(Funky::ConnectionError) }
end

shared_examples 'cumulative views' do
  it 'only returns the views from this post (not cumulative ones)' do
    expect(video.view_count).to be > 50_000_000
  end
end

shared_examples 'non-existing video' do
  it { expect {video}.to raise_error(Funky::ContentNotFound) }
end
