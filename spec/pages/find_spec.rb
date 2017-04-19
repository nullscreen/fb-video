require 'spec_helper'
require 'pages/shared/examples'

describe 'Page' do
  let(:existing_page_id) { '1191441824276882' }
  let(:unknown_page_id) { 'does-not-exist' }

  describe '.find(page_id)' do
    let(:page) { Funky::Page.find(page_id) }

    context 'given an existing page ID was passed' do
      let(:page_id) { existing_page_id }

      include_examples 'id and name properties'
      include_examples 'location properties'
    end

    context 'given a non-existing page ID was passed' do
      let(:page_id) { unknown_page_id }

      it { expect { page }.to raise_error(Funky::ContentNotFound) }
    end
  end
end
