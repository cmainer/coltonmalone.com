class PagesController < ApplicationController
  def index
    require 'rss'
    # rss = RSS::Parser.parse(open('https://medium.brianemory.com/feed').read, false).items[0..2]
    rss = RSS::Parser.parse(open('https://medium.com/feed/@coltonmalone').read, false).items[0..2]
    @posts = []
    run_sanitizer
    rss.each do |result|
      result = { title: get_title(result.title),
                 date: get_date(result.pubDate),
                 link: get_link(result.link),
                 heading: get_heading(result.content_encoded),
                 content: get_content(result.content_encoded) }
      @posts.push(result)
    end
  end

  def path
    begin
      erb = ERB.new(File.join("pages", params[:path]))
      render erb.result
    rescue ActionView::MissingTemplate => e
      raise ActionController::RoutingError.new("Not found")
    end
  end

  private
  def get_title(title)
    title
  end

  def get_date(date)
    date > 1.day.ago ? "#{time_ago_in_words(date)} ago" : date.strftime('%b %d, %Y')
  end

  def get_link(link)
    link[/[^?]+/]
  end

  def get_heading(content)
    @sanitizer.sanitize(content.sub(/(<h4>|<h3>)/, '<Z>')
                               .sub(/(<\/h4>|<\/h3>)/, '<Z>')[/(<Z>).*(<Z>)/])
  end

  def get_content(content)
    @sanitizer.sanitize(content.sub(/(<figure>).*(<\/figure>)/, '')
                               .truncate(300, separator: ' ')
                               .sub(/(<h4>|<h3>).*(<\/h4>|<\/h3>)/, ''))
  end

  def run_sanitizer
    @sanitizer = Rails::Html::FullSanitizer.new
  end
end
