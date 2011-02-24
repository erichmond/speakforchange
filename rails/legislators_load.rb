require 'csv'
reader = CSV.open("legislators.csv", "r") 

header = reader.shift
Legislator.delete_all

reader.each do |row|
  x = Legislator.new
  row.each_with_index do |value, i|
    field = header[i]
    puts "#{field}: #{value}"
    x.send("#{field}=", value)
  end
  if x.title =~ /Sen/
    x.write_attribute('type', 'Senator')
  else
    x.write_attribute('type', 'Representative')
  end
  puts x.inspect
  x.save
  puts
end
