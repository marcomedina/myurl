require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require './environments'


class Url < ActiveRecord::Base
  validates_presence_of :url, :message => 'You must specify a URL.'
  validates :url, format: { with: URI.regexp }, if: Proc.new { |a| a.url.present? }
  validates :key, uniqueness: true

  after_create :add_key

  private
  def add_key
    if not self.key
      self.key = self.id.to_s(36)
      self.save
    end
  end
end

before do
  response["Content-Type"] = "application/json"
  if request.request_method == 'OPTIONS'
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "POST"

    halt 200
  end
end

get '/:key' do
  @url = Url.find_by key: params[:key]
  @url.seen += 1
  @url.save!
  redirect @url.url
end

post '/' do
  @url = Url.find_by url: params[:url]
  if @url
    json @url
  else
    @url = Url.new url: params[:url], key: params[:key]
    if @url.save
      json @url
    else
      json @url.errors
    end
  end
end

get '/all' do
  @urls = Url.all
  json @urls
end

