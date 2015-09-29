require 'telegram/bot'

require_relative 'youtube_ripper'

# CommunicationHandler
class CommunicationHandler
  def initialize(bot)
    @bot = bot
    @stage = 0
    @youtube_ripper = YoutubeRipper.new
  end

  def handle(current_message)
    @current_message = current_message
    return unless @current_message.text
    case @stage
    when 0 then search_songs
    when 1 then download_song
    end
  end

  def search_songs
    return do_not_understand unless @current_message.text.start_with?('/mp3')

    keywords = @current_message.text.gsub('/mp3', '').strip
    return keyword_missing if keywords.empty?

    @search_results = @youtube_ripper.search_videos keywords

    suggestions = @search_results.keys
    send_message('Select one song or type /cancel',
                 reply_kb_markup(suggestions))
    @stage += 1
  end

  def download_song
    song_title = @current_message.text
    return cancel_operation if song_title == '/cancel'
    return do_not_understand unless @search_results.key?(song_title)

    send_message 'Well done... I\'ll message you when song is ready :)'

    file_path = retrieve_mp3(song_title)
    return something_went_wrong unless File.exist?(file_path)

    send_document(file_path)
    @youtube_ripper.remove_mp3(file_path)
    @stage = 0
  end

  private

  def cancel_operation
    send_message 'Download aborted'
    @stage = 0
  end

  def do_not_understand
    send_message 'Sorry but I can\'t understand you...'
    @stage = 0
  end

  def something_went_wrong
    send_message 'Sorry but something went wrong, try again'
    @stage = 0
  end

  def keyword_missing
    send_message 'You have to specify at least one keyword, '\
                 'see /help for command usage'
    @stage = 0
  end

  def reply_kb_markup(layout)
    Telegram::Bot::Types::ReplyKeyboardMarkup
      .new(keyboard: layout,
           one_time_keyboard: true,
           resize_keyboard: true)
  end

  def reply_kb_hide
    Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
  end

  def send_message(text, reply_markup = reply_kb_hide)
    @bot.api.send_message(chat_id: @current_message.chat.id,
                          text: text,
                          reply_markup: reply_markup)
  end

  def send_document(file_path)
    @bot.api.send_document(chat_id: @current_message.chat.id,
                           document: File.new(file_path))
  end

  def retrieve_mp3(song_title)
    video_url = @search_results[song_title]
    file_name = "#{song_title}.mp3"
    @youtube_ripper.retrieve_mp3(video_url, file_name)
    "downloads/#{file_name}"
  end
end
