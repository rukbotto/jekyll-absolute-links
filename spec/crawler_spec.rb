require "spec_helper"

describe(JekyllAbsoluteLinks::Crawler) do
  let(:overrides) { Hash.new }
  let(:site_config) do
    Jekyll.configuration(Jekyll::Utils.deep_merge_hashes({
      "source" => File.expand_path("../fixtures/absolute-links", __FILE__),
      "destination" => File.expand_path("../dest", __FILE__)
    }, overrides))
  end
  let(:site) { Jekyll::Site.new(site_config) }

  before(:each) do
    site.process
  end

  context("When development environment is active") do
    describe("Crawler") do
      it("performs no link transformation on posts") do
        url = "\"/posts/curabitur-sed-condimentum-enim/\""
        expect(site.posts[0].output).to include(url)
      end

      it("performs no link transformation on pages") do
        url = "\"/posts/lorem-ipsum-dolor-sit-amet/\""
        expect(site.pages[1].output).to include(url)
      end

      it("performs no link transformation on feeds") do
        url = ">/posts/lorem-ipsum-dolor-sit-amet/<"
        expect(site.pages[0].output).to include(url)
      end

      it("performs no encoded link transformation on feeds") do
        url = "&quot;/posts/lorem-ipsum-dolor-sit-amet/&quot;"
        expect(site.pages[0].output).to include(url)
      end
    end
  end

  context("When production environment is active") do
    around(:each) do |example|
      ENV["JEKYLL_ENV"] = "production"
      example.run
    end

    describe("Crawler") do
      it("transforms relative urls to absolute urls on posts") do
        url = "\"http://example.com/posts/curabitur-sed-condimentum-enim/\""
        expect(site.posts[0].output).to include(url)
      end

      it("transforms relative urls to absolute urls on pages") do
        url = "\"http://example.com/posts/lorem-ipsum-dolor-sit-amet/\""
        expect(site.pages[1].output).to include(url)
      end

      it("transforms relative urls to absolute urls on feeds") do
        url = ">http://example.com/posts/lorem-ipsum-dolor-sit-amet/<"
        expect(site.pages[0].output).to include(url)
      end

      it("transforms relative encoded urls to absolute urls on feeds") do
        url = "&quot;http://example.com/posts/lorem-ipsum-dolor-sit-amet/&quot;"
        expect(site.pages[0].output).to include(url)
      end
    end

    context("And site domain has a trailing slash") do
      let(:overrides) do
        {
          "url" => "http://example.com/"
        }
      end

      describe("Crawler") do
        it("Removes duplicate slashes from urls on posts") do
          url = "\"http://example.com/posts/curabitur-sed-condimentum-enim/\""
          expect(site.posts[0].output).to include(url)
        end

        it("Removes duplicate slashes from urls on pages") do
          url = "\"http://example.com/posts/lorem-ipsum-dolor-sit-amet/\""
          expect(site.pages[1].output).to include(url)
        end

        it("Removes duplicate slashes from urls on feeds") do
          url = ">http://example.com/posts/lorem-ipsum-dolor-sit-amet/<"
          expect(site.pages[0].output).to include(url)
        end

        it("Removes duplicate slashes from encoded urls on feeds") do
          url = "&quot;http://example.com/posts/lorem-ipsum-dolor-sit-amet/&quot;"
          expect(site.pages[0].output).to include(url)
        end
      end
    end
  end
end
