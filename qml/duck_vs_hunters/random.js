function randomIntFromInterval(min, max){
    return Math.floor(Math.random()*(max-min)+min);
}

function randomInt(max){
    return randomIntFromInterval(0, max);
}

function getRandomElementOfArray(arr){
    var index = randomInt(arr.length);
    return arr[index];
}
