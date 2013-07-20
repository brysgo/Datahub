require 'em-twitter'

class Twitter < Project
  acts_as_singleton
  after_initialize :setup_model_attributes

  def setup_model_attributes
    self.title = 'Twitter'
    self.saved_state = {} unless self.saved_state.present?
    @options = {
      :path   => '/1.1/statuses/sample.json',
      :oauth  => {
        :consumer_key     => ENV['CONSUMER_KEY'],
        :consumer_secret  => ENV['CONSUMER_SECRET'],
        :token            => ENV['OAUTH_TOKEN'],
        :token_secret     => ENV['OAUTH_TOKEN_SECRET']
      }
    }
  end

  def incoming(dep, data)
    self.emit(JSON.parse(data))
  end

  def start_connection
    EM.run do
      @client = EM::Twitter::Client.connect(@options)

      @client.each do |result|
        self.incoming(self.id, result)
      end

      @client.on_error do |message|
        puts "oops: error: #{message}"
      end

      @client.on_unauthorized do
        puts "oops: unauthorized"
      end

      @client.on_forbidden do
        puts "oops: unauthorized"
      end

      @client.on_not_found do
        puts "oops: not_found"
      end

      @client.on_not_acceptable do
        puts "oops: not_acceptable"
      end

      @client.on_too_long do
        puts "oops: too_long"
      end

      @client.on_range_unacceptable do
        puts "oops: range_unacceptable"
      end

      @client.on_enhance_your_calm do
        puts "oops: enhance_your_calm"
      end
    end
  end
end

