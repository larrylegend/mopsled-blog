module Jekyll
  module Filters
    def relative_date(date)
      relative_date_in_words date
    end
  end
end

# Non-original source
# Taken from StackOverflow user MattW. and modified
# http://stackoverflow.com/a/195894/770938
def relative_date_in_words(date)
  a = (Time.now - date).to_i

  case a
    when 0 then 'just now'
    when 1 then 'a second ago'
    when 2..59 then a.to_s+' seconds ago' 
    when 60..119 then 'a minute ago' #120 = 2 minutes
    when 120..3540 then (a/60).to_i.to_s+' minutes ago'
    when 3541..7100 then 'an hour ago' # 3600 = 1 hour
    when 7101..82800 then ((a+99)/3600).to_i.to_s+' hours ago' 
    when 82801..172000 then 'a day ago' # 86400 = 1 day
    when 172001..518400 then ((a+800)/(60*60*24)).to_i.to_s+' days ago'
    when 518400..1036800 then 'a week ago'
    else ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
  end
end