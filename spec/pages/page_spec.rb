require 'spec_helper'

describe 'Page' do
  let(:existing_page_id) { '1487249874853741' }
  let(:unknown_page_id) { 'does-not-exist' }
  let(:another_page_id) { '526533744142224' }

  describe '.where(id: page_ids)' do
    let(:pages) { Funky::Page.where(id: page_ids) }

    context 'given one existing page ID was passed' do
      let(:page_ids) {existing_page_id}
      let(:page) {pages.first}

      it { expect(page.id).to be_a(String) }
      it { expect(page.username).to be_a(String) }
      it { expect(page.name).to be_a(String) }
    end

    context 'given one unknown page ID was passed' do
      let(:page_ids) {unknown_page_id}

      it { expect(pages).to be_empty }
    end

    context 'given multiple existing page IDs were passed' do
      let(:page_ids) { [existing_page_id, another_page_id] }
      specify 'returns one page for each id, in the same order provided' do
        expect(pages.map &:id).to eq(page_ids)
      end
    end

    context 'given an unknown page id passed with an existing page id' do
      let(:page_ids) { [existing_page_id, unknown_page_id] }

      specify 'returns only the existing pages' do
        expect(pages.map &:id).to eq([existing_page_id])
      end
    end

    context 'given a Faraday::ConnectionFailed error' do
      let(:page_ids) { [existing_page_id, another_page_id] }
      let(:socket_error) { SocketError.new }

      before { expect(Net::HTTP).to(receive(:start).and_raise socket_error) }

      it { expect { pages }.to raise_error(Funky::ConnectionError) }
    end
  end
end