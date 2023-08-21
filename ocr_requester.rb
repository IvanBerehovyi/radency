require 'bunny'
require 'json'

class OCRRequester
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue('ocr_queue')
  end

  def send_request(file_url)
    payload = { 'File URL' => file_url }
    @queue.publish(payload.to_json)
    puts "Request sent for processing: #{file_url}"
  end

  def close
    @connection.close
  end
end

# Create an instance of the OCRRequester and send a sample request
requester = OCRRequester.new
requester.send_request('https://previews.123rf.com/images/happyroman/happyroman1611/happyroman161100004/67968361-ATM-transaction-printed-paper-receipt-bill-vector.jpg')
requester.close
