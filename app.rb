require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require './environments'
require 'haml'


class Url < ActiveRecord::Base
  validates_presence_of :url, :message => 'You must specify a URL.'
  validates :url, format: { with: URI.regexp }, if: Proc.new { |a| a.url.present? }
  validates :key, uniqueness: true

  after_create :add_key

  private
  def add_key
    if self.key.empty?
      self.key = self.id.to_s(36)
    end

    if not self.save
      self.key = (0...8).map { (65 + rand(26)).chr }.join
      self.save
    end
  end
end

get '/all' do
  @urls = Url.all
  json @urls
end

get '/' do
  haml :index
end

get '/:key' do
  @url = Url.find_by key: params[:key]
  if not @url
    status 404
    return json error: 'Not Found'
  end
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
