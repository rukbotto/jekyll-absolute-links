module JekyllAbsoluteLinks
  class Crawler
    @regexp = %r{<code[\S\s]*?/code>|(?<="|'|>|=|&quot;|&apos;|&gt;|&equals;)(?<url>/[\w/.-]*)(?!>|&gt;)}

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
          url = $~[:url]
          new_url =
            if url != nil
              "#{site_url}#{url}".gsub(%r{(\w)/+}, "\\1/")
            else
              $~[0]
            end
          new_url
        end
      end
    end
  end
end
