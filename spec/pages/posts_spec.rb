require 'spec_helper'

describe 'Page' do
  let(:fullscreen_page_id) { 'FullscreenInc' }

  describe '#posts' do
    let(:page) { Funky::Page.find(page_id) }
    let(:posts) { page.posts }

    context 'given an existing page ID was passed' do
      let(:page_id) { fullscreen_page_id }

      specify 'returns a list of posts' do
        post = posts.first

        expect(posts).to all be_a Funky::Post
        expect(post.type).to be_a String
        expect(post.created_time).to be_a DateTime
      end

      specify 'returns more than one page of posts' do
        expect(posts.count).to be > 100
      end

      specify 'includes the oldest post of the page' do
        expect(posts.map {|post| post.id}).to include '221406534569729_363440160366365'
      end
    end
  end
end
