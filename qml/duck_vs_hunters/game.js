function damageTarget(target, value) {
    if(target.damaged){
        target.damaged(value);
    }

    target.hp -= value;

    if(target.hp <= 0){
        target.die();
    }
}

