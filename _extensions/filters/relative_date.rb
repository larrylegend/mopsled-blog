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
    when 0..86400 then 'today' 
    when 86401..172800 then 'yesterday'
    when 172801..518400 then ((a+800)/(60*60*24)).to_i.to_s+' days ago'
    when 518400..1036800 then 'a week ago'
    else ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
  end
end