
Vue.component('dropzone', {
    props: {id:{type:String}, url:{type:String, required:true}, paramName:{type:String}, params:{type:Object}},
    template: '<div :id="id"></div>',
    mounted: function() {

      var reqData = $.extend({ moquiSessionToken:this.$root.moquiSessionToken}, this.params);

      new Dropzone(this.$el, { url: this.url, paramName:this.paramName, params:reqData});
    }
})

Vue.component('ckeditor', {
    props: {id:{type:String}, content:{type:String}, feedUrl:{type:String}, name:{type:String, required:true}},
    data: function() { return {
      ClassicEditor:ClassicEditor,
      feedItems : [
        { id: '@swarley', userId: '1', name: 'Barney Stinson', link: 'https://www.imdb.com/title/tt0460649/characters/nm0000439' },
        { id: '@lilypad', userId: '2', name: 'Lily Aldrin', link: 'https://www.imdb.com/title/tt0460649/characters/nm0004989' },
        { id: '@marshmallow', userId: '3', name: 'Marshall Eriksen', link: 'https://www.imdb.com/title/tt0460649/characters/nm0781981' },
        { id: '@rsparkles', userId: '4', name: 'Robin Scherbatsky', link: 'https://www.imdb.com/title/tt0460649/characters/nm1130627' },
        { id: '@tdog', userId: '5', name: 'Ted Mosby', link: 'https://www.imdb.com/title/tt0460649/characters/nm1102140' }
      ]
    }},
    template: '<div><textarea :id="id">{{content}}</textarea><input type="hidden" :name="name" :value="content"/></div>',
    methods:{
      getFeedItems:function( queryText ) {
          return new Promise( resolve => {
              /*
              setTimeout( () => {
                  const itemsToDisplay = this.feedItems
                      // Filter out the full list of all items to only those matching the query text.
                      .filter( isItemMatching )
                      // Return 10 items max - needed for generic queries when the list may contain hundreds of elements.
                      .slice( 0, 10 );
                  resolve( itemsToDisplay );
              }, 100 );
              */

              if (!this.feedUrl || this.feedUrl.length === 0) return;

              var reqData = { moquiSessionToken: this.$root.moquiSessionToken };

              $.ajax({ type:"POST", url:this.feedUrl, data:reqData, dataType:"json", headers:{Accept:'application/json'},
                error:moqui.handleAjaxError, success: function(feedItems) {
                const itemsToDisplay = feedItems.filter( isItemMatching ).slice( 0, 10 )
                resolve(itemsToDisplay)
              }});
          });

          // Filtering function - it uses the `name` and `username` properties of an item to find a match.
          function isItemMatching( item ) {
              // Make the search case-insensitive.
              const searchString = queryText.toLowerCase();

              // Include an item in the search results if the name or username includes the current user input.
              return (
                  item.name.toLowerCase().includes( searchString ) ||
                  item.id.toLowerCase().includes( searchString )
              );
          }
      }
    },
    mounted: function() {
      let editor;
      var jqEl = $(this.$el);
      ClassicEditor.create( this.$el.querySelector('textarea'), {
        mention: {
          feeds: [{
                marker: '@',
                //feed: [ '@Barney', '@Lily', '@Marshall', '@Robin', '@Ted' ],
                feed: this.getFeedItems,
                minimumCharacters: 0
              }
          ]
        },
        image: {
            resizeUnit: 'px'
        }
      }).then( newEditor => {
          editor = newEditor;
          editor.model.document.on( 'change:data', () => {
            //console.log( '---------The data has changed!-----------------'  + editor.getData());
            jqEl.children("input").first().val(editor.getData())
          });
      } ).catch( error => {
          console.error( error );
      });
    }
});


Vue.component('tree-item', {
    template:
    '<li :id="model.id">' +
        '<i v-if="isFolder" @click="toggle" class="glyphicon" :class="{\'glyphicon-chevron-right\':!open, \'glyphicon-chevron-down\':open}"></i>' +
        '<i v-else :class="{\'glyphicon glyphicon-unchecked\': !selected, \'glyphicon glyphicon-check\': selected}"></i>' +
        ' <span @click="setSelected">' +
            '<m-link v-if="model.a_attr" :href="model.a_attr.urlText" :load-id="model.a_attr.loadId" :class="{\'text-success\':selected}">{{model.text}}</m-link>' +
            '<span v-if="!model.a_attr" :class="{\'text-success\':selected}">{{model.text}}</span>' +
        '</span>' +
        '<ul v-show="open" v-if="hasChildren"><tree-item v-for="model in model.children" :key="model.id" :model="model" :top="top"/></ul></li>',
    props: { model:Object, top:Object },
    data: function() { return { open:false }},
    computed: {
        isFolder: function() { var children = this.model.children; if (!children) { return false; }
            if (moqui.isArray(children)) { return children.length > 0 } return true; },
        hasChildren: function() { var children = this.model.children; return moqui.isArray(children) && children.length > 0; },
        selected: function() { return this.top.currentPath === this.model.id; }
    },
    watch: { open: function(newVal) { if (newVal) {
        var children = this.model.children;
        var url = this.top.items;
        if (this.open && children && moqui.isBoolean(children) && moqui.isString(url)) {
            var li_attr = this.model.li_attr;
            var allParms = $.extend({ moquiSessionToken:this.$root.moquiSessionToken, treeNodeId:this.model.id,
                treeNodeName:(li_attr && li_attr.treeNodeName ? li_attr.treeNodeName : ''), treeOpenPath:this.top.currentPath }, this.top.parameters);
            var vm = this; $.ajax({ type:'POST', dataType:'json', url:url, headers:{Accept:'application/json'}, data:allParms,
                error:moqui.handleAjaxError, success:function(resp) { vm.model.children = resp; } });
        }
    }}},
    methods: {
        toggle: function() { if (this.isFolder) { this.open = !this.open; } },
        setSelected: function() { this.top.currentPath = this.model.id; this.open = true; }
    },
    mounted: function() {
        if (this.model.state && this.model.state.opened) { this.open = true; };
        if (this.isFolder) { this.open = true }
    }
});

Vue.component('container-dialog', {
    props: { id:{type:String,required:true}, title:String, width:{type:String,'default':'760'}, openDialog:{type:Boolean,'default':false} },
    data: function() {
        var viewportWidth = $(window).width();
        return { isHidden:true, dialogStyle:{width:(this.width < viewportWidth ? this.width : viewportWidth) + 'px'}}},
    template:
    '<div :id="id" class="modal dynamic-dialog" aria-hidden="true" style="display:none;" tabindex="-1">' +
        '<div class="modal-dialog" :style="dialogStyle"><div class="modal-content">' +
            '<div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
                '<h4 class="modal-title">{{title}}</h4></div>' +
            '<div class="modal-body"><slot></slot></div>' +
        '</div></div>' +
    '</div>',
    methods: { hide: function() { $(this.$el).modal('hide'); } },
    mounted: function() {
        var jqEl = $(this.$el); var vm = this;
        jqEl.on("hidden.bs.modal", function() { vm.isHidden = true; });
        jqEl.on("shown.bs.modal", function() { vm.isHidden = false;
            jqEl.find(":not(.noResetSelect2)>select:not(.noResetSelect2)").select2({ });
            var defFocus = jqEl.find(".default-focus");
            if (defFocus.length) { defFocus.focus(); } else { jqEl.find("form :input:visible:not([type='submit']):first").focus(); }
        });
        if (this.openDialog) { jqEl.modal('show'); }

        //https://code-examples.net/en/q/bfd512
        $(".modal-header").css('cursor', 'move');

        $(".modal-header").on("mousedown", function(mousedownEvent) {
            var $modalHeader = $(this);
            var x = mousedownEvent.pageX - $modalHeader.offset().left,
                y = mousedownEvent.pageY - $modalHeader.offset().top;
            $("body").on("mousemove.draggable", function(mousemoveEvent) {
                $modalHeader.closest(".modal-dialog").offset({
                    "left": mousemoveEvent.pageX - x,
                    "top": mousemoveEvent.pageY - y
                });
            });
            $("body").one("mouseup", function() {
                $("body").off("mousemove.draggable");
            });
            $modalHeader.closest(".modal").one("hidden.bs.modal", function() {
                $("body").off("mousemove.draggable");
            });
        });
    }
});