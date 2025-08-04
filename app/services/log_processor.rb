class LogProcessor
  def initialize(log_file)
    @log_file = log_file
  end

  def process
    File.open(@log_file, "r") do |file|
      file.each_line do |line|
        process_line(line)
      end
    end
  end

  private

  def process_line(line)
    # Placeholder for line processing logic
    puts "Processing line: #{line.strip}"
  end
end
