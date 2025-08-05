# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require_relative '../app/services/log_parser'

puts "Limpando o banco de dados..."
Kill.delete_all
ItemPickup.delete_all
QuestCompletion.delete_all
BossKill.delete_all
GameEvent.delete_all
Player.delete_all

puts "Processando o log do jogo..."
# Coloque o seu arquivo de log na raiz do projeto ou em um diretório como `lib/logs`
LogParser.parse('game_log_large.txt')

puts "Carga de dados finalizada!"
