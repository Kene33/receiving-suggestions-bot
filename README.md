# Telegram Bot for receives offers for [@it_prog_chat](http://t.me/it_prog_chat)
## This is a simple bot that forwards chat suggestions to the admin. This makes it easier for the admin to view and understand the wishes of chat participants. 
## How to start
### First install all gem
```
bundle install
```

### Secondly enter your token and admin ID into the bot. 8 and 11 line.
### Thirdly, launch the bot. Please note that you must have the current version of Ruby and all gems installed
```
ruby main.rb
```
## Notes
The file log_all.txt stores all suggestions in the form of text from users for all time. The admin can get them through the /get_log command in the bot. If you also want the bot to send stickers, then uncomment line 67
