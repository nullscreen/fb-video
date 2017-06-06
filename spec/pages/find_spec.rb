require 'spec_helper'
require 'pages/shared/examples'

describe 'Page' do
  let(:existing_page_id) { '1191441824276882' }
  let(:unknown_page_id) { 'does-not-exist' }
  let(:website_url) { 'https://www.facebook.com/pg/FoxMovies/videos/?ref=page_internal' }

  describe '.find(page_id)' do
    let(:page) { Funky::Page.find(page_id) }

    context 'given an existing page ID was passed' do
      let(:page_id) { existing_page_id }

      include_examples 'id and name properties'
      include_examples 'location properties'

      it { expect(page.fan_count).to be_an(Integer) }
      it { expect([true, false]).to include(page.has_featured_video?)}
    end

    context 'given a non-existing page ID was passed' do
      let(:page_id) { unknown_page_id }

      it { expect { page }.to raise_error(Funky::ContentNotFound) }
    end

    context 'given an invalid URI was passed' do
      let(:page_id) { ' some invalid URL ' }

      it { expect { page }.to raise_error(Funky::ContentNotFound) }
    end

    context 'given a website url was passed' do
      let(:page_id) { website_url }

      it { expect { page }.to raise_error Funky::ContentNotFound }
    end
  end
end
