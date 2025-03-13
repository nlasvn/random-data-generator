def create_random_data []: nothing -> record {
    (1..1000) | each {
        let temperatura = random int 5..40
        let luminosidade = random int 0..1000
        let umidade = random int 0..100
        let datetime = generate_random_datetime

        { temperatura: $temperatura, luminosidade: $luminosidade, umidade: $umidade, datetime: $datetime }
    }
}

def generate_random_datetime []: nothing -> string {
    let day = random int 1..28 | add_zero_left
    let month = random int 1..12 | add_zero_left
    let year = 2025

    let hours = random int 0..23 | add_zero_left
    let minutes = random int 0..59 | add_zero_left
    let seconds = random int 0..59 | add_zero_left

    $"($year)-($month)-($day) ($hours):($minutes):($seconds)"
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
        $"INSERT INTO dados \(temperatura, luminosidade, umidade, date) VALUES \(($row.temperatura), ($row.luminosidade), ($row.umidade), ($row.datetime));"
    } | str join "\n"
}

generate_sql