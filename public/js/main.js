;(function($) {
  var app = Sammy('#app', function() {

    this.get('#/', function() {
      this.$element().html('<ul></ul>');

      $.get('/all', function(res) {
        res.forEach(function(i) {
          $("#app ul").append('<li><a href="/'+ i.key +'" target="_blank"><span class="tab">/'+ i.key +' => '+ i.url +'</span></a></li>');
        });
      });

      this.$element().append('<br/><a href="#/add">Add New</a>')
    });

    this.get('#/add', function() {
      var self = this,
          form = '\
        <div>\
          <label>Url</label>\
          <input type="text" id="url" />\
          <label>Custom Key</label>\
          <input type="text" id="key" />\
          <input type="button" id="save" value="Save" />\
        </div>\
      ';

      this.$element().html('');
      this.$element().append(form);
      this.$element().append('<br/><a href="#/">< Back to list</a>');
      $('#save').on('click', function() {
        var params = {
          url: $('#url').val(),
          key: $('#key').val()
        };

        $.post('/', params, function(res) {
          self.$element().append('<br/><span>Url Created</span>');
          self.$element().append('<br/><a href="/'+ res.key +'" target="_blank"><span class="tab">/'+ res.key +' => '+ res.url +'</span></a>');
        });
      });
    });

  });


  $(function() {
    app.run()
  });
})(jQuery);
