require 'open-uri'
require 'nokogiri'

# YoutubeRipper
class YoutubeRipper
  def search_videos(keywords)
    youtube_url = "https://www.youtube.com/results?search_query=#{keywords}"
    escaped_url = URI.escape(youtube_url)
    doc = Nokogiri::HTML(open(escaped_url).read)

    fetch_results(doc)
  end

  def retrieve_mp3(youtube_url, file_name)
    std_params = "-f 'bestaudio/best' -x --audio-format mp3 --prefer-ffmpeg"
    params = "\"#{youtube_url}\" -o \"downloads/#{file_name}\" #{std_params}"
    `youtube-dl #{params}`
  end

  def remove_mp3(file_path)
    `rm \"#{file_path}\"`
  end

  private

  def fetch_results(doc)
    search_results = {}
    doc.css('ol.item-section li').each do |element|
      video_link = element.css('h3.yt-lockup-title a').first
      next unless valid_link? video_link
      video_name = video_link.content.gsub(/[^a-zA-Z0-9\s\-_']/, '')
      video_url = "https://www.youtube.com#{video_link['href']}"
      search_results[video_name] = video_url
    end
    search_results
  end

  def valid_link?(video_link)
    video_link && video_link['href'] && video_link['href'].include?('watch')
  end
end
