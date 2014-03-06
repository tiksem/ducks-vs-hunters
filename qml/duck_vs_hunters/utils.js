function ItemPauseHandler(item){
    this.item = item;
}
ItemPauseHandler.prototype = {
    pause: function(){
        if(this.pausedItems)
        {
            return;
        }

        var pausedItems = this.pausedItems = [];
        var pauseAction = function(item){
            if(item.paused !== undefined && !item.paused){
                if(item.running !== undefined && item.running){
                    pausedItems.push(item);
                    item.paused = true;
                }
            } else if(item.running !== undefined && item.running) {
                pausedItems.push(item);
                item.running = false;
            }

            var children = item.children;
            if(children){
                for(var i = 0; i < children.length; i++){
                    var child = children[i];
                    if(child){
                        pauseAction(child);
                    }
                }
            }
        }

        pauseAction(this.item);
    },

    resume: function(){
        if(!this.pausedItems){
            return;
        }

        var items = this.pausedItems;
        var len = items.length;

        for(var i = 0; i < len; i++){
            var item = items[i];

            if(item.paused !== undefined){
                if(item.running !== undefined){
                    item.paused = false;
                }
            } else if(item.running !== undefined) {
                item.running = true;
            }
        }

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
