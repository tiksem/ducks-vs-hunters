function indexOf(array, item){
    for(var i in array){
        if(array[i] === item){
            return i;
        }
    }

    return -1;
}

function findAndRemove(array, item) {
    var index = indexOf(array, item);
    if(index >= 0){
        array.splice(index, 1);
    }

    return index;
}

function count(array){
    var count = 0;
    for(var i in array){
        count++;
    }
    return count;
}
