$(document).ready(function() {



  $('.payment-form').on('submit', function(event){
    event.preventDefault();
    var form = $(this).closest('form');
    makePayment(form);
    form.find('input[name=transaction_type]').val('Pay');
  });


  var makePayment = function(form){
    debugger
    var request = $.ajax({
      url: form.attr('action'),
      type: form.attr('method'),
      data: form.serialize(),
      dataType: 'JSON',
    });

    request.done(function(response){
      var table = $('.completed-transactions-table tbody');
      table.prepend(response.html);
      $('.payment-form')[0].reset()
    });

    request.fail(function(httpResponse){
      alert(httpResponse.responseText);
    });
  };

  $('.login-button').on('click', function(event){
   event.preventDefault();
   alert("Unfortunately Venmo just revoked our API access, so we can't link your account anymore :( ");
  });

});
