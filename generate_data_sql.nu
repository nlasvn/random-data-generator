def create_random_data []: nothing -> record {
    1..10000 | each {
        let temperatura = random int 5..40
        let luminosidade = random int 0..1000
        let umidade = random int 0..100
        let timestamp = generate_random_timestamp

        { temperatura: $temperatura, luminosidade: $luminosidade, umidade: $umidade, timestamp: $timestamp }
    }
}

def generate_random_timestamp []: nothing -> string {
    let now = (date now) | into record
    let year = $now.year - (random int 0..2)

    let hours = random int 0..23 | add_zero_left
    let minutes = random int 0..59 | add_zero_left
    let seconds = random int 0..59 | add_zero_left

    let time = { hours: $hours, minutes: $minutes, seconds: $seconds }

    match year {
        _ if $year == $now.year => (create_date_current_year $now $time)
        _ => (create_date $year $time)
    }
}

def create_date_current_year [now: record, time: record]: nothing -> string {
    let day = $now.day - (random int 1..($now.day - 1)) | add_zero_left
    let month = $now.month - (random int 0..($now.month - 1)) | add_zero_left

    $"($now.year)-($month)-($day) ($time.hours):($time.minutes):($time.seconds)"
}

def create_date [year: int, time: record]: nothing -> string {
    let day = random int 1..28 | add_zero_left
    let month = random int 1..12 | add_zero_left

    $"($year)-($month)-($day) ($time.hours):($time.minutes):($time.seconds)"
}

def add_zero_left []: int -> string {
    # $in is a special variable, it will store the piped value
    match $in {
        $num if $num <= 9 => $"0($num)"
        _ => $"($in)"
    }
}

def generate_sql []: nothing -> string {
    let rows = create_random_data

    $rows | each { |row|
        $"INSERT INTO sensor_data \(temperatura, luminosidade, umidade, recorded_at) VALUES \(($row.temperatura), ($row.luminosidade), ($row.umidade), ($row.timestamp));"
    } | str join "\n"
}

generate_sql