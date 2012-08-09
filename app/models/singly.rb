require 'httparty'

class Singly
  SINGLY_API_BASE = "https://api.singly.com"

  def initialize(token)
    @token = token
  end

  def checkins(opts)
    start = Time.now
    data = HTTParty.get(SINGLY_API_BASE + '/types/checkins', {
      :query => opts.merge(:access_token => @token)
    }).parsed_response
    opts[:fields] ? Singly.expand_fields(data) : data
  end

private

  def self.expand_fields(data)
    data.map do |datum|
      item = {}

      datum.keys.each do |field|
        cursor = item
        pieces = field.split('.')
        pieces[0...-1].each do |piece|
          cursor[piece] ||= {}
          cursor = cursor[piece]
        end
        cursor[pieces.last] = datum[field]
      end

      item
    end
  end

end
