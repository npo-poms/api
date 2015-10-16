require 'addressable/uri'
require 'net/http'
require 'base64'
require 'openssl'
require 'json'
require 'singleton'

# Ruby2 Poms Client
# require './poms_client'
class PomsClient
  include Singleton

  HOST   = 'rs.poms.omroep.nl'
  ORIGIN = 'http://my-origin.nl'
  KEY    = 'MY-KEY'
  SECRET = 'MY-SECRET'
  PATH   = '/v1/api/'

  # PomsClient.instance.find('POMS_S_NTR_470249')
  def find mid
    get "media/#{mid}"
  end

  # PomsClient.instance.search(query: 'Argos', params: { max: 10 } )
  # PomsClient.instance.search(query: { searches: { types: ['SERIES'] }, sort: { sortDate: 'DESC' } })
  def search query:, params: {}
    search_hash = query
    search_hash = { searches: { text: { value: query } } } if query.is_a?(String)
    post 'media', data: search_hash, params: params
  end

private

  def get path, params: {}
    url = build_url(path, params: params)
    request = Net::HTTP::Get.new url.to_s
    fetch_response(url, request)
  end

  def post path, data: {}, params: {}
    url = build_url(path, params: params)
    request = Net::HTTP::Post.new url.to_s
    request.body = data.to_json
    fetch_response(url, request)
  end

  def build_url path, params: {}
    url = Addressable::URI.join(HOST, PATH, path)
    url.query_values = params
    url
  end

  def fetch_response url, request
    add_headers(url, request)
    JSON.parse(http.request(request).body)
  end

  def add_headers url, request
    headers = {
      'origin'      => ORIGIN,
      'x-npo-date'  => Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S %z').gsub('-0000', 'GMT'),
      'uri'         => url.path
    }

    message = (headers.to_a + url.query_values.to_a.sort).map{|param| param.join(':') }.join(',')
    encrypted_message = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), SECRET, message)).strip

    request['Accept']         = 'application/json'
    request['Content-Type']   = 'application/json'
    request['Origin']         = headers['origin']
    request['Authorization']  = "NPO #{KEY}:#{ encrypted_message }"
    request['X-NPO-Date']     = headers['x-npo-date']

    request
  end

  def http
    @http ||= begin
      http = Net::HTTP.new(HOST)
      http.read_timeout = 500
      http
    end
  end

end