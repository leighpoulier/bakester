# https://ruby-doc.org/stdlib-2.6.1/libdoc/date/rdoc/DateTime.html#method-i-strftime

Time::DATE_FORMATS[:day_month_year] = '%e %b %Y'  # eg 3 Jan 2021
Time::DATE_FORMATS[:hour_minute] = '%H:%M'  # eg 3 Jan 2021 04:23
Time::DATE_FORMATS[:hour_minute_day_month_year] = '%H:%M %e %b %Y'  # eg 3 Jan 2021 04:23