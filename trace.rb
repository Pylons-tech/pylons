#! /usr/bin/ruby
require "json"
require "base64"
require "google/cloud/bigquery"

class TraceTable
  attr_reader :table
  
  def self.create_table #Only need this once, but whatever.
    dataset = @bigquery.create_dataset "chain"
    dataset.create_table "trace" do |t|
      t.name = "Chain Traces"
      t.description = "Traces from the trace-store option on the Pylons chain."
      t.schema do |s|
        s.string "operation", mode: :required
        s.string "key", mode: :required
        s.integer "block_height", mode: :required
        s.string "store_name", mode: :required
        s.string "value", mode: :required
      end
    end
  end
  
  def initialize
      if !cloud? do
        Google::Cloud::Bigquery.configure do |config|
          config.project_id  = "zinc-interface-241613"
          config.credentials = "/home/big-dipper/bigquery_keyfile.json"
        end
      end
      @bigquery = Google::Cloud::Bigquery.new
      @table = @bigquery.dataset("chain").table("trace")
    end
  end
end

def cloud?; ENV["env"] == "prod"; end

def boring json
  return true if ["staking","slashing","upgrade"].member? json["store_name"]
  return true if ["read"].member? json["operation"]
end

def massage json
  json["key"] = Base64.decode64 json["key"]
  json["value"] = Base64.decode64 json["value"]
  json["block_height"] = json["metadata"]["blockHeight"].to_i
  json["store_name"] = json["metadata"]["store_name"]
  json.delete("metadata")
  json
end

table = TraceTable.new().table if cloud?

def deliver json
  return table.insert json if cloud?
  puts json
end

puts "Starting logger with cloud =" + cloud?.to_s

ARGF.each_line{|line| json = massage JSON.parse line
    next if boring json
    result = deliver table.insert(json)
    puts result.insert_errors.map(&:errors) if result
}