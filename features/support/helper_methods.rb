def noko_doc
  Nokogiri::HTML(response.body)
end

def get_element_via_selector(selector)
  noko_doc.css(selector).first # TODO might be able to make this a tad faster
end

def get_action_buttons_text
  puts noko_doc.to_s
  noko_doc.css("div#actions div.action span").map(&:inner_html)
end

def get_action_buttons
  noko_doc.css("div#actions div.action")
end

def lookup_private_nickname(name)
  { "Lexington Terminal RR" => 'ltr',
    "Midland Railroad Co." => 'mid',
    "Waycross & Southern RR" => 'wsr',
    "Ocilla Southern RR" => 'osr',
    "Macon & Birmingham RR" => 'mbr' }[name]
end
