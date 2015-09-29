#!/usr/bin/env ruby

require 'telegram/bot'
require 'yaml'

require_relative 'communication_handler'

# Mp3JukeBot
class Mp3JukeBot
  TOKEN = YAML.load_file('config.yml')['bot_token']

  attr_accessor :current_message

  def initialize(bot)
    @bot = bot
    @communications = {}
  end

  def start
    help
  end

  def help
    help_msg = "Hello #{current_message.from.first_name}!\n"\
               'My name is Mp3JukeBot and I\'m here to help you '\
               "find your favourite songs.\n\n"\
               "You can control me with the following commands:\n"\
               "/mp3 keywords - Find a song\n"\
               "/help - Show this help message\n\n"\
               "Example of usage: \n /mp3 coldplay ink"
    @bot.api.send_message(chat_id: current_message.chat.id, text: help_msg)
  end

  def handle_communication
    @communications[current_message.chat.id] ||= CommunicationHandler.new(@bot)
    @communications[current_message.chat.id].handle(current_message)
  end
end

Telegram::Bot::Client.run(Mp3JukeBot::TOKEN) do |bot|
  mp3_juke_bot = Mp3JukeBot.new bot

  bot.listen do |message|
    mp3_juke_bot.current_message = message
    case message.text
    when '/start'
      mp3_juke_bot.start
    when '/help'
      mp3_juke_bot.help
    else
      mp3_juke_bot.handle_communication
    end
  end
end
