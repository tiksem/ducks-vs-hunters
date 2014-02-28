function readObjectFromFile(fileName) {
    var value = Utils.readFromFile(fileName);
    try
    {
        return JSON.parse(value);
    }
    catch(e)
    {
        return {};
    }
}

function writeObjectToFile(fileName, obj){
    var str = JSON.stringify(obj);
    Utils.writeToFile(fileName, str);
}
