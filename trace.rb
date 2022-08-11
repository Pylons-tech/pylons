require "json"
require "base64"

ARGF.each_line{|line| j = JSON.parse line
  next if ["staking","slashing"].member? j["metadata"]["store_name"]
  j["key"] = Base64.decode64 j["key"]
  puts j
}