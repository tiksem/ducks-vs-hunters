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

function getItemCenter(item){
    return {
        x: getItemCenterX(item),
        y: getItemCenterY(item)
    }
}

function isPointInsideCircle(pointX, pointY, circleX, circleY, radius){
    return radius * radius > sqrDistance(pointX, pointY, circleX, circleY);
}

function circleCollide(circle1, circle2){
    var sqrDist = sqrDistance(circle1.x, circle1.y, circle2.x, circle2.y);
    var sqrRadiusDistance = circle1.radius + circle2.radius
    sqrRadiusDistance *= sqrRadiusDistance;
    return sqrRadiusDistance > sqrDist;
}

function itemCircleCollide(a, b){
    var aCenter = Geom.getItemCenter(a);
    var bCenter = Geom.getItemCenter(b);

    aCenter.radius = a.radius;
    bCenter.radius = b.radius;
    return circleCollide(aCenter, bCenter);
}
