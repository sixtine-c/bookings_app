class Api::V1::BaseController < ActionController::API
  private

  def http_request_post(body)
    uri = URI('http://localhost:3000/api/v1/missions')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = body
    http.request(req)
  end

  def http_request_patch(url, body)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Patch.new(uri.path, 'Content-Type' => 'application/json')
    req.body = body
    http.request(req)
  end

  def http_request_delete(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Delete.new(uri)
    http.request(req)
  end
end
