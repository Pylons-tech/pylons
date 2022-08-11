require "json";

ARGF.each_line{|line| j = JSON.parse(line);
  next if ["staking","slashing"].member?(j["metadata"]["store_name"]) 
  puts j
}