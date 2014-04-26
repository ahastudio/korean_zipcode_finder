# encoding: utf-8

require "korean_zipcode_finder/version"
require 'korean_zipcode_finder/configuration'
require 'engine' if defined?(Rails)

require 'net/http'
require 'open-uri'
require 'nokogiri'


module KoreanZipcodeFinder
  extend Configuration
  Struct.new("KoreanZipcodeFinder", "zipcode", "zipcode_01", "zipcode_02", "address", "original_address")

  def self.find_zipcode(dong_name)
    keyword = dong_name.strip

    uri = URI(Configuration::URL)
    uri.query = URI.encode_www_form(q: keyword)
    response = Net::HTTP.get_response(uri)
    nodes = JSON.parse(response.body)['results']

    nodes.map do |node|
      original_address = node['address'].to_s
      address = original_address.strip.sub(/\s(산|)(\d+)(~?)(\d+)(동|)\z/, "").sub(/\s(\d+)(-?)\((\d+)(~?)(\d+)\)\z/, "")
      zipcode = node['code6'].to_s
      zipcode_01 = zipcode[0,3]
      zipcode_02 = zipcode[-3,3]

      Struct::KoreanZipcodeFinder.new(zipcode, zipcode_01, zipcode_02, address, original_address)
    end
  end
end
