require 'open-uri'
require 'pry'
require 'json'
require 'net/http'
require 'active_support/core_ext/hash'
require 'xml/to/json'


class ProductsController < ApplicationController

  def index
    @products = Product.all
    # doc = Nokogiri::XML( open('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'))
    a = Net::HTTP.get_response(URI.parse('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml')).body
    doc = JSON.parse(Hash.from_xml(a).to_json)['Envelope']['Cube']['Cube']
    # xml = Nokogiri::XML(open('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'))
    # doc = JSON.parse(JSON.pretty_generate(xml.root))
    puts "*****doc"
    puts doc.inspect
    # binding.pry
    @products = doc
    puts "=="
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price_in_cents)
  end
end
