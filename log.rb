module Logs
  def self.log(message)
    time = Time.at(message.date)
    time_set = time.strftime("%Y-%m-%d  %H:%M:%S ")
    file_path = 'log_all.txt'

    log_yes = "User: @#{message.from.username} | #{message.text} | Time: #{time_set}\n"
    log_no  = "User: #{message.chat.id} | #{message.text} | Time: #{time_set}\n"

    if message.from.username
      File.open(file_path, 'a') { |file| file.write(log_yes) }
    else
      File.open(file_path, 'a') { |file| file.write(log_no) }
    end
  end
end
