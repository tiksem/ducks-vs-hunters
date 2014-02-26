.import Qt 2.0 as Qt

function sqrDistance(aX, aY, bX, bY){
    var xs = 0;
    var ys = 0;

    xs = aX - bX;
    xs = xs * xs;

    ys = aY - bY;
    ys = ys * ys;

    return xs + ys;
}

function getItemCenterX(item){
    return item.x + item.width / 2;
}

function getItemCenterY(item){
    return item.y + item.height / 2;
}

function isPointInsideCircle(pointX, pointY, circleX, circleY, radius){
    return radius * radius > sqrDistance(pointX, pointY, circleX, circleY);
}
