def create_random_data []: nothing -> record {
    1..10000 | each {
        let temperatura = random int 5..40
        let luminosidade = random int 0..1000
        let umidade = random int 0..100
        let datetime = generate_random_datetime

        { temperatura: $temperatura, luminosidade: $luminosidade, umidade: $umidade, datetime: $datetime }
    }
}

def generate_random_datetime []: nothing -> string {
    let today = (date now) | into record
    let year = $today.year - (random int 0..2)

    let hours = random int 0..23 | add_zero_left
    let minutes = random int 0..59 | add_zero_left
    let seconds = random int 0..59 | add_zero_left

    let time = { hours: $hours, minutes: $minutes, seconds: $seconds }

    match year {
        _ if $year == $today.year => (create_date_current_year $today $time)
        _ => (create_date $year $time)
    }
}

def create_date_current_year [today, time] {
    let day = $today.day - (random int 1..($today.day - 1)) | add_zero_left
    let month = $today.month - (random int 0..($today.month - 1)) | add_zero_left

    $"2025-($month)-($day) ($time.hours):($time.minutes):($time.seconds)"
}

def create_date [year, time] {
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
        $"INSERT INTO dados \(temperatura, luminosidade, umidade, data) VALUES \(($row.temperatura), ($row.luminosidade), ($row.umidade), ($row.datetime));"
    } | str join "\n"
}

generate_sql