$(function() {});

var PNB = function() {
  return {
    formFocusFirst: function(form) {
      $('#' + form + ' input:visible:enabled:first').focus()
    },

    updateSortables: function(parent) {
      var elems = $(parent + ' ul li .position'), i = 1
      elems.each(function() {
        this.value = i++
      })
    },

    sizeTehToolbars: function() {
      $('.textile-toolbar').each(function() {
        box_id = this.id.replace('textile-toolbar-', '')
        $(this).css('width', $('#' + box_id).css('width'))
      })
    }
  };
}();
