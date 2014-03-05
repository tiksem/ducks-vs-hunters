function generateArrayFromRange(a, b, length) {
    var result = [];

    var increment = (length - 1) / (b - a);
    var value = a + increment;

    result[0] = a;
    result[length - 1] = b;

    for(var i = 1; i < length - 1; i++){
        result[i] = value;
        value += increment;
    }

    return result;
}

function deegresToRadians(value){
    return 0.0174532925 * value;
}
