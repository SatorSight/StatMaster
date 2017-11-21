let colors = {
    1: 'crimson',
    2: 'blueviolet',
    3: 'cornflowerblue',
    4: 'cornflowerblue',
    5: 'yellow',
    6: 'tomato',
    7: 'teal',
    8: 'deeppink',
    9: 'lightseagreen'
};

let lastColor = 1;

export default function () {
    let color = colors[lastColor];
    if (color === undefined) {
        lastColor = 1;
        color = colors[lastColor];
    }
    lastColor++;
    return color;
}