App.addChild('Project', _.extend({
  el: '#main_content[data-action="show"][data-controller-name="projects"]',

  events: {
    'click #toggle_warning a' : 'toggleWarning',
    'click a#embed_link' : 'toggleEmbed'
  },

  activate: function(){
    this.$warning = this.$('#project_warning_text');
    this.$embed= this.$('#project_embed');
    this.route('about');
    this.route('updates');
    this.route('backers');
    this.route('comments');
    this.route('edit');
    this.route('reports');
    this.route('budget');
    this.route('project_faqs');
    this.route('terms');
    $('#accordion').accordion();

    $('#new-user-question-modal').on('show', function () {
      $.ajax({
        url: $(".new-user-question-modal-link").data('url'),
        beforeSend: function(){},
        success: function(txt){
          $("#new-user-question-modal .content").html(txt);
        }
      });
    });

    if(window.location.hash == '#open-new-user-question-modal'){
      $('#new-user-question-modal').modal('show')
    }
  },

  toggleWarning: function(){
    this.$warning.slideToggle('slow');
    return false;
  },

  toggleEmbed: function(){
    this.loadEmbed();
    this.$embed.slideToggle('slow');
    return false;
  },

  followRoute: function(name){
    var $tab = this.$('nav#project_menu a[href="' + window.location.hash + '"]');
    if($tab.length > 0){
      this.onTabClick({ target: $tab });
    }
  },

  loadEmbed: function() {
    var that = this;

    if(this.$embed.find('.loader').length > 0) {
      $.get(this.$embed.data('path')).success(function(data){
        that.$embed.html(data);
      });
    }
  }
}, Skull.Tabs));
