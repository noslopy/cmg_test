require "json"

class SensorEvaluator
    def initialize(log_contents_str)
        log_format_json = File.read("./format.json")
        @log_formats = JSON.parse(log_format_json)
        @reference, @devices = parse_log(log_contents_str)
    end

    def devices
        devices_with_eval = {}
        @devices.each{|device| devices_with_eval[device[:name]] = evaluate(device)}
        devices_with_eval
    end

    private

    def parse_log(log_contents_str)
        log_records = log_contents_str.split("\n")
        reference = {}
        devices = []
        log_records.each do |record|
            if record.split(' ')[0] == 'reference'
                reference = parse_reference(record)
            elsif @log_formats.map{ |device| device['type'] }.include? record.split(' ')[0]
                device = record.split(' ')
                devices << { name: device[1], type: device[0], logs: [] }
            else
                log_data = record.split(' ')
                devices.last[:logs] <<  { timestamp: log_data[0], value: log_data[1].to_f }
            end
        end
        [reference, devices]
    end

    def parse_reference(reference_raw)
        reference = {}
        reference_values = reference_raw.split(' ')        
        for i in 1..@log_formats.length()
            reference[@log_formats[i-1]['measure_unit']] = reference_values[i].to_f
        end
        reference
    end

    def evaluate(device)
        for log_format in @log_formats
            device_format, eval_rules = log_format, log_format['classification'] if log_format['type'] == device[:type]
        end
        eval_rules.keys.each do |rank|
            rank_valid = true
            rules = eval_rules[rank]
            rules.each do |rule|
                rule = rule.split(' ')
                rank_valid = rule_valid?(device, rule, device_format)
                break unless rank_valid   
            end
            return rank if rank_valid || eval_rules.keys.last == rank
        end
    end

    def rule_valid?(device, rule, log_format)
        diff = rule[1].to_f
        case rule[0]
        when 'within'    
            device[:logs].each do |log|
                if  log[:value] + diff < @reference[log_format['measure_unit']] ||
                    log[:value] - diff > @reference[log_format['measure_unit']]
                    return false
                end
            end
            true
        when 'mean'
            numbers = device[:logs].map { |log| log[:value] }
            mean = calculate_mean(numbers)
            mean + diff > @reference[log_format['measure_unit']] &&
            mean - diff < @reference[log_format['measure_unit']] 
        when 'sd'
            values = device[:logs].map { |log| log[:value] }
            sd = calculate_sd(values)
            sd < diff
        else
            false
        end
    end

    def calculate_mean(numbers)
        sum = 0
        numbers.each { |num| sum += num }
        sum / numbers.length()
    end

    def calculate_sd(numbers)
        mean = calculate_mean(numbers)
        new_values = []
        numbers.each {|number| new_values << (number - mean) ** 2}
        new_mean = calculate_mean(new_values)
        puts Math.sqrt(new_mean) 
        Math.sqrt(new_mean)
    end
end