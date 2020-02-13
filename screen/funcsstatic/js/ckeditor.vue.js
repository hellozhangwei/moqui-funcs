
Vue.component('ckeditor', {
    props: { id:{type:String,required:false}, name:{type:String, required:true}},
    data: function() { return {ClassicEditor:ClassicEditor}},
    template: '<textarea id="editor" :name="name"></textarea>',
    mounted: function() {
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
      });
    }
});