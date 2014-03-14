function iterateChildren(item, callback){
    var iteratedChildren = []

    var iterate = function(item){
        if(callback(item)){
            iteratedChildren.push(item);
        }

        var children = item.data;
        if(children){
            for(var i = 0; i < children.length; i++){
                var child = children[i];
                if(child){
                    iterate(child);
                }
            }
        }
    }

    iterate(item);
    return iteratedChildren;
}

function ItemPauseHandler(item){
    this.item = item;
}
ItemPauseHandler.prototype = {
    pause: function(){
        console.log("pause");

        if(this.pausedItems)
        {
            return;
        }

        var pauseAction = function(item){
            if(item.paused !== undefined && !item.paused){
                item.paused = true;
                return true;
            }

            if(item.running !== undefined && item.running) {
                item.running = false;
                return true;
            }

            return false;
        }

        Utils.pauseTimers();
        this.pausedItems = iterateChildren(item, pauseAction);
    },

    resume: function(){
        console.log("resume");

        if(!this.pausedItems){
            return;
        }

        var items = this.pausedItems;
        var len = items.length;

        for(var i = 0; i < len; i++){
            var item = items[i];

            if(item.paused !== undefined){
                item.paused = false;
            } else if(item.running !== undefined) {
                item.running = true;
            }
        }

        Utils.resumeTimers();
        delete this.pausedItems;
    },

    isPaused: function(){
        return this.pausedItems !== undefined;
    },

    togglePausedState: function(){
        if(this.isPaused()){
            this.resume();
        } else {
            this.pause();
        }
    }
}
