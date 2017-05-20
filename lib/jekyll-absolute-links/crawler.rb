module JekyllAbsoluteLinks
  class Crawler
    @regexp = %r{<(?!code)[^<>]*((href|src)=("|')|>)(([^<>]*(?<=&quot;))?(?<url>/[^<> ]*)((?=&quot;)[^<>]*)?)("|'|<(?!/code))[^<>]*>}

    Jekyll::Hooks.register :posts, :post_render do |post|
      next if Jekyll::env == "development"
      transform(post.output, @regexp, post.site.config["url"])
    end

    Jekyll::Hooks.register :pages, :post_render do |page|
      next if Jekyll::env == "development"
      transform(page.output, @regexp, page.site.config["url"])
    end

    class << self
      private
      def transform(output, regexp, site_url)
        output.gsub!(regexp) do |match|
          url = Regexp.last_match[:url]
          match.gsub(url, "#{site_url}#{url}".sub(%r{(\w)/+}, "\\1/"))
        end
      end
    end
  end
end
