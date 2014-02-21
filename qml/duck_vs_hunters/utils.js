.import Qt 2.0 as Qt

function setTimeout(parent, callback, timeout) {
    var obj = Qt.createQmlObject('import Qt 4.7; Timer {running: false; repeat: false; interval: ' + timeout + '}', parent, "setTimeout");
    obj.triggered.connect(callback);
    obj.running = true;

    return obj;
}

function clearTimeout(timer) {
    timer.running = false;
    timer.destroy(1);

    return timer;
}
