
Vue.component('dropzone', {
    props: {id:{type:String}, url:{type:String, required:true}},
    template: '<div :id="id"></div>',
    mounted: function() {
      new Dropzone(this.$el, { url: this.url});
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