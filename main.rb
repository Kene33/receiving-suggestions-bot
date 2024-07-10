require 'telegram/bot'
require 'json'
require 'concurrent'
require 'rainbow'

require_relative 'log'

token = 'your_token'

pool = Concurrent::ThreadPoolExecutor.new(min_threads: 1, max_threads: 50, max_queue: 100)
admins = [6847163023] # admins id who receives the message example [6847163023, 973465836, 353535346]


Telegram::Bot::Client.run(token) do |bot|
  bot_info = bot.api.getMe
  bot_usernames = bot_info.username

  puts Rainbow("@#{bot_usernames} запущен.").green
  puts Rainbow("by t.me/kenee33").green

  bot.listen do |message|

    if message.text == "/start"
      task = Concurrent::ScheduledTask.new(1) {
        bot.api.send_message(chat_id: message.chat.id, text: "Привет, я бот предложка на чата t.me/it_prog_chat.\nОтправь мне фото, текст, либо документ и администрация рассмотрит твое предложение.")
      }
      pool.post { task.execute }

    elsif message.text == "/get_log"
      if admins.include?(message.chat.id)
        begin
          path_to_files = File.expand_path("log_all.txt")
          bot.api.send_document(chat_id: message.chat.id, document: Faraday::UploadIO.new(path_to_files, 'json/txt'))
        rescue
          bot.api.send_message(chat_id: message.chat.id, text: "Произошла какая то ошибка")
        end
      end

    elsif message.text
      task = Concurrent::ScheduledTask.new(1) {
        admins.each do |ids|
          bot.api.forward_message(chat_id: ids, from_chat_id: message.chat.id, message_id: message.message_id)
        end}
      pool.post { task.execute }
      Logs.log(message)

    elsif message.photo
      task = Concurrent::ScheduledTask.new(1) {
        admins.each do |ids|
          bot.api.send_photo(chat_id: ids, photo: message.photo.last.file_id, has_spoiler: true, caption: "User: @#{message.from.username}\nId: #{message.chat.id}") if message.from.username
          bot.api.send_photo(chat_id: ids, photo: message.photo.last.file_id, has_spoiler: true, caption: "User: #{message.chat.id}") if not message.from.username
        end}
      pool.post { task.execute }

    elsif message.document
      task = Concurrent::ScheduledTask.new(1) {
        admins.each do |ids|
          bot.api.send_document(chat_id: ids, document: message.document.file_id, caption: "User: @#{message.from.username}\nId: #{message.chat.id}") if message.from.username
          bot.api.send_document(chat_id: ids, document: message.document.file_id, caption: "User: #{message.chat.id}") if not message.from.username
        end}
      pool.post { task.execute }

    elsif message.sticker
      task = Concurrent::ScheduledTask.new(1) {
        admins.each do |ids|
          bot.api.send_message(chat_id: ids, text: "Отправьте текст или фото. Не отправляйте стикеры.")
        end}
      pool.post { task.execute }

    else
      bot.api.send_message(chat_id: message.chat.id, text: "Отправьте текст, фото или документ.")
      Logs.log(message)
    end
  end
end
