require_relative '../app/services/log_parser'

puts "Limpando o banco de dados..."
Kill.delete_all
ItemPickup.delete_all
QuestCompletion.delete_all
BossKill.delete_all
GameEvent.delete_all
Player.delete_all

puts "Criando token de acesso..."
token = ApiToken.create!
puts "Token de acesso criado: #{token.token}"

puts "Processando o log do jogo..."
LogParser.parse('game_log_large.txt')

puts "Carga de dados finalizada!"
