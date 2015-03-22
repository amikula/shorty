desc "Cleans up broken urls created before URL validation was deployed"
task fix_invalid_urls: [:environment] do
  total = 0
  fixed = []
  not_fixed = []

  Url.all.each do |u|
    total += 1

    unless u.valid?
      u.url = "http://" + u.url
      if u.valid? && u.save
        fixed << u
      else
        not_fixed << u
      end
    end
  end

  puts "Total urls in database: #{total}"
  puts "Urls fixed: #{fixed.length}"
  puts "Urls not fixed: #{not_fixed.length}"

  if fixed.length > 0
    puts "\nThe following Urls have been fixed:"
    fixed.each do |u|
      puts "  #{u.url} (#{u.external_url})"
    end
  end

  if not_fixed.length > 0
    puts "\nThe following Urls could not be fixed:"
    not_fixed.each do |u|
      puts "  #{u.url} (#{u.external_url})"
    end
  end
end
