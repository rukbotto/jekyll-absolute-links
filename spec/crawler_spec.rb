require "spec_helper"

describe JekyllAbsoluteLinks::Crawler do
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

  context "When development environment is active" do
    describe "Crawler" do
      it "performs no link transformation on posts" do
        a = "<a href=\"/posts/curabitur-sed-condimentum-enim/\">"
        expect(site.posts[0].output).to include(a)
      end

      it "performs no embedded link transformation on posts" do
        a = "<a href=\"https://www.facebook.com/sharer.php?u=/posts/lorem-ipsum-dolor-sit-amet/\">"
        expect(site.posts[0].output).to include(a)
      end

      it "performs no link transformation on pages" do
        a = "<a href=\"/posts/lorem-ipsum-dolor-sit-amet/\">"
        expect(site.pages[1].output).to include(a)
      end

      it "performs no link transformation on sitemaps" do
        loc = "<loc>/posts/lorem-ipsum-dolor-sit-amet/</loc>"
        expect(site.pages[2].output).to include(loc)
      end

      it "performs no link transformation on feeds" do
        atom_link = "<atom:link href=\"/feed.xml\" rel=\"self\" type=\"application/rss+xml\"/>"
        expect(site.pages[0].output).to include(atom_link)

        link = "<link>/posts/lorem-ipsum-dolor-sit-amet/</link>"
        expect(site.pages[0].output).to include(link)
      end

      it "performs no link transformation on feeds" do
        a = <<-eos
        <description>&lt;p&gt;Curabitur sed condimentum enim. Integer ut velit vitae ante facilisis
consequat. Nullam egestas ipsum sit amet nibh ornare, non consequat massa
dictum. Fusce porttitor iaculis velit elementum feugiat. Lorem ipsum dolor sit
amet, consectetur adipiscing elit. Morbi nisi tortor, aliquet et eros id,
cursus tincidunt sapien. &lt;a href=&quot;/posts/lorem-ipsum-dolor-sit-amet/&quot;&gt;Lorem ipsum dolor sit amet&lt;/a&gt;.&lt;/p&gt;

</description>
eos
        expect(site.pages[0].output).to include(a)
      end
    end
  end

  context "When production environment is active" do
    around(:each) do |example|
      ENV["JEKYLL_ENV"] = "production"
      example.run
    end

    describe "Crawler" do
      it "transforms relative links to absolute links on posts" do
        a = "<a href=\"http://example.com/posts/curabitur-sed-condimentum-enim/\">"
        expect(site.posts[0].output).to include(a)
      end

      it "transforms embedded relative links to absolute links on posts" do
        a = "<a href=\"https://www.facebook.com/sharer.php?u=http://example.com/posts/lorem-ipsum-dolor-sit-amet/\">"
        expect(site.posts[0].output).to include(a)
      end

      it "transforms relative links to absolute links on pages" do
        a = "<a href=\"http://example.com/posts/lorem-ipsum-dolor-sit-amet/\">"
        expect(site.pages[1].output).to include(a)
      end

      it "transforms relative links to absolute links on sitemaps" do
        loc = "<loc>http://example.com/posts/lorem-ipsum-dolor-sit-amet/</loc>"
        expect(site.pages[2].output).to include(loc)
      end

      it "transforms relative links to absolute links on feeds" do
        atom_link = "<atom:link href=\"http://example.com/feed.xml\" rel=\"self\" type=\"application/rss+xml\"/>"
        expect(site.pages[0].output).to include(atom_link)

        link = "<link>http://example.com/posts/lorem-ipsum-dolor-sit-amet/</link>"
        expect(site.pages[0].output).to include(link)
      end

      it "transforms relative links to absolute links on feeds" do
        a = <<-eos
        <description>&lt;p&gt;Curabitur sed condimentum enim. Integer ut velit vitae ante facilisis
consequat. Nullam egestas ipsum sit amet nibh ornare, non consequat massa
dictum. Fusce porttitor iaculis velit elementum feugiat. Lorem ipsum dolor sit
amet, consectetur adipiscing elit. Morbi nisi tortor, aliquet et eros id,
cursus tincidunt sapien. &lt;a href=&quot;http://example.com/posts/lorem-ipsum-dolor-sit-amet/&quot;&gt;Lorem ipsum dolor sit amet&lt;/a&gt;.&lt;/p&gt;

</description>
eos
        expect(site.pages[0].output).to include(a)
      end

      it "performs no link transformation for absolute links" do
        a = "<a href=\"https://jekyllrb.com\">"
        expect(site.posts[0].output).to include(a)
      end

      it "performs no link transformation inside inline code snippets" do
        code = "<code class=\"highlighter-rouge\">/</code>"
        expect(site.posts[0].output).to include(code)
      end

      it "performs no link transformation inside multiline code snippets" do
        code = "<code>&lt;a href=\"/\"&gt;Hello&lt;/a&gt;\n</code>"
        expect(site.posts[0].output).to include(code)
      end

      it "performs no link transformation inside highlighted code snippets" do
        code = "<code><span class=\"nt\">&lt;a</span> <span class=\"na\">href=</span><span class=\"s\">\"/\"</span><span class=\"nt\">&gt;</span>Hello<span class=\"nt\">&lt;/a&gt;</span>\n</code>"
        expect(site.posts[0].output).to include(code)
      end
    end

    context "And site domain has a trailing slash" do
      let(:overrides) do
        {
          "url" => "http://example.com/"
        }
      end

      describe "Crawler" do
        it "removes duplicate slashes from links on posts" do
          a = "<a href=\"http://example.com/posts/curabitur-sed-condimentum-enim/\">"
          expect(site.posts[0].output).to include(a)
        end

        it "removes duplicate slashes from embedded links on posts" do
          a = "<a href=\"https://www.facebook.com/sharer.php?u=http://example.com/posts/lorem-ipsum-dolor-sit-amet/\">"
          expect(site.posts[0].output).to include(a)
        end

        it "removes duplicate slashes from links on pages" do
          a = "<a href=\"http://example.com/posts/lorem-ipsum-dolor-sit-amet/\">"
          expect(site.pages[1].output).to include(a)
        end

        it "removes duplicate slashes from links on sitemaps" do
          loc = "<loc>http://example.com/posts/lorem-ipsum-dolor-sit-amet/</loc>"
          expect(site.pages[2].output).to include(loc)
        end

        it "removes duplicate slashes from links on feeds" do
          atom_link = "<atom:link href=\"http://example.com/feed.xml\" rel=\"self\" type=\"application/rss+xml\"/>"
          expect(site.pages[0].output).to include(atom_link)

          link = "<link>http://example.com/posts/lorem-ipsum-dolor-sit-amet/</link>"
          expect(site.pages[0].output).to include(link)
        end

        it "removes duplicate slashes from encoded links on feeds" do
        a = <<-eos
        <description>&lt;p&gt;Curabitur sed condimentum enim. Integer ut velit vitae ante facilisis
consequat. Nullam egestas ipsum sit amet nibh ornare, non consequat massa
dictum. Fusce porttitor iaculis velit elementum feugiat. Lorem ipsum dolor sit
amet, consectetur adipiscing elit. Morbi nisi tortor, aliquet et eros id,
cursus tincidunt sapien. &lt;a href=&quot;http://example.com/posts/lorem-ipsum-dolor-sit-amet/&quot;&gt;Lorem ipsum dolor sit amet&lt;/a&gt;.&lt;/p&gt;

</description>
eos
          expect(site.pages[0].output).to include(a)
        end
      end
    end
  end
end
