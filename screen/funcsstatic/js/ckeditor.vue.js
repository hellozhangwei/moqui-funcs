
Vue.component('ckeditor', {
    props: {id:{type:String}, content:{type:String}, name:{type:String, required:true}},
    data: function() { return {ClassicEditor:ClassicEditor}},
    template: '<div><textarea id="editor">{{content}}</textarea><input type="hidden" :name="name" :value="content"/></div>',
    mounted: function() {
      let editor;
      var jqEl = $(this.$el);
      ClassicEditor.create( document.querySelector( '#editor' ), {
        mention: {
          feeds: [
              {
                marker: '@',
                feed: [ '@Barney', '@Lily', '@Marshall', '@Robin', '@Ted' ],
                minimumCharacters: 0
              }
          ]
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