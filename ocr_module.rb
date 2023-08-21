require 'bunny'
require 'httparty'
require 'tesseract'

class OCRModule
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue('ocr_queue')
    @tesseract = Tesseract::Engine.new
  end

  def process_queue
    @queue.subscribe(block: true) do |_, _, body|
      begin
        payload = JSON.parse(body)
        file_url = payload['File URL']

        puts "Processing image from #{file_url}"

        image_data = HTTParty.get(file_url)
        ocr_result = perform_ocr(image_data)

        puts "OCR Result: #{ocr_result}"
      rescue StandardError => e
        puts "Error processing image: #{e.message}"
      end
    end
  end

  # ... (other methods)

  def close
    @connection.close
  end
end

# Create an instance of the OCRModule and start processing the queue
module_instance = OCRModule.new
module_instance.process_queue
