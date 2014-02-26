function damageTarget(target, value) {
    target.hp -= value;

    if(target.hp <= 0){
        target.die();
    }
}

