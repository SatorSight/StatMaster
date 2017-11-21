export function in_array(needle, haystack) {
    let result = false;
    haystack.map((element) => {
        if (needle === element)
            result = true;
    });
    return result;
}

export function merge_data(data1, data2) {
    let dates_array = [];
    let result_array = [];

    const whole_data = data1.concat(data2);
    whole_data.map((element) => {
        dates_array = push_if_not_there(element['date'], dates_array)
    });

    dates_array.map((date) => {
        let element = {};
        element['date'] = date;

        whole_data.map((data_piece) => {
            if (data_piece['date'] === date)
                Object.keys(data_piece).map((key) => {
                    if (key.indexOf('date') === -1)
                        element[key] = data_piece[key];
                });
        });

        result_array.push(element);
    });
    return result_array;
}

export function push_if_not_there(needle, haystack) {
    if (!in_array(needle, haystack))
        haystack.push(needle);
    return haystack;
}

// export default {in_array, push_if_not_there, merge_data}