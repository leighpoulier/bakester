// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "bootstrap";

$(document).on('turbolinks:load', function() {
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  });
});

// $(document).ready(function() {
$(document).on('turbolinks:load', function() {
  $('#bakester-search-form-activate').click(function() {
      $('#bakester-search-form').toggleClass('open');
      $(this).toggleClass('up');
  });
});

// new_bake_jobs modal show
$(document).on('turbolinks:load', function() {
  $('#newBakeJobsModal').modal('show');
});
