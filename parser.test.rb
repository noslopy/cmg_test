require './parser'

logfile = File.open("sample1.txt")
logfile_data_raw = logfile.read
logfile.close

se = SensorEvaluator.new(logfile_data_raw)
devices = se.devices()
puts devices