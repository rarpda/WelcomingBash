from telegramBot.telegramMessenger import Messenger as telegram
import sys

telegram().send_message(sys.argv[1])
