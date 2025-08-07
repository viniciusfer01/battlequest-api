namespace :log do
  desc "Importa novos eventos do log do jogo sem duplicar dados."
  task import: :environment do
    log_filepath = Rails.root.join("game_log_large.txt")

    unless File.exist?(log_filepath)
      puts "Arquivo de log não encontrado em: #{log_filepath}"
      next
    end

    last_timestamp = GameEvent.maximum(:event_timestamp)

    puts "Iniciando importação de logs..."
    if last_timestamp
      puts "Importando apenas eventos após: #{last_timestamp}"
    else
      puts "Nenhum evento anterior encontrado. Importando o log completo."
    end

    new_events_count = 0

    File.foreach(log_filepath) do |line|
      next if line.strip.empty?

      timestamp_str, time_str = line.strip.split(/\s+/, 3)
      begin
        current_timestamp = Time.parse("#{timestamp_str} #{time_str}")
      rescue ArgumentError
        next
      end

      next if last_timestamp && current_timestamp <= last_timestamp

      LogParser.parse_line(line)
      new_events_count += 1
    end

    puts "Importação finalizada. Foram adicionados #{new_events_count} novos eventos."
  end
end
