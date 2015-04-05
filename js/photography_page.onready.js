$(function(){
  $('.gallery a').featherlightGallery({
    afterContent: function(e){
      var height = $('.featherlight-content', this.$instance).height();

      $('img', this.$content).attr('style', 'max-height:' + (height - 30) + 'px;');

      var width = $('.featherlight-content', this.$instance).width();

      $('.caption', this.$content).attr('style', 'width:' + width + 'px;');
    }
  });
});