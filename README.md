# Mp3JukeBot
Mp3JukeBot is a Ruby Telegram bot that lets you download mp3 from youtube videos.

## Installation

Before installing Mp3JukeBot make sure you have [youtube-dl](https://github.com/rg3/youtube-dl) and [ffmpeg](https://www.ffmpeg.org/) correctly installed on your environment.

Install dependencies:
```shell
gem install telegram-bot-ruby nokogiri
```
Clone Repository:
```shell
git clone https://github.com/lorenzo-ange/Mp3JukeBot.git
cd Mp3JukeBot
```
Set your Telegram Bot Token:
```shell
echo "bot_token: YOUR_BOT_TOKEN" >> config.yml
```
Let mp3_juke_bot.rb be executable:
```shell
chmod +x mp3_juke_bot.rb
```
## Usage
To launch Mp3JukeBot:
```shell
./mp3_juke_bot.rb
```
