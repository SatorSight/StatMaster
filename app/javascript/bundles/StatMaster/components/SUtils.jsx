export function in_array(needle, haystack) {
    // let result = false;
    // haystack.map((element) => {
    //     if (needle === element)
    //         result = true;
    // });
    // return result;

    return haystack.indexOf(needle) !== -1;
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

export function toggle_array_element(needle, haystack) {
    if (!in_array(needle, haystack))
        haystack.push(needle);
    else
        haystack = remove_array_element(needle, haystack);

    return haystack;
}

export function remove_array_element(needle, haystack) {
    let resulting_array = [];
    haystack.map((element) => {
        if (element !== needle)
            resulting_array.push(element);
    });
    return resulting_array;
}


// export function ServiceStatsArray() { }
// ServiceStatsArray.prototype = [];
//
// ServiceStatsArray.prototype.setService = function(service) {
//     this.service = service;
//     return this;
// };
//
// ServiceStatsArray.prototype.getService = function() {
//     return this.service;
// };


// export default {in_array, push_if_not_there, merge_data}