$(document).ready(function() {


  $('.payment-form input[type=submit]').on('click', function(event){
    var submitButton = $(this);
    submitButton.closest('form').find('input[name=transaction_type]').val(submitButton.val());
  });

  $('.payment-form').on('submit', function(event){
    event.preventDefault();
    console.log('hello')
    var form = $(this).closest('form');
    makePayment(form);
    form.find('input[name=transaction_type]').val('Pay');
  });

  $('.accept').on('click', function(event){
    event.preventDefault();
    console.log('caught accept')
    approve.call(this);
  });

  $('.reject').on('click', function(event){
    event.preventDefault();
    console.log('caught accept')
    approve.call(this);
  });


  var approve = function(){

    console.log(this) // used with approve.call()
    var row = $(this).attr('data-id')

    var request = $.ajax({
      url: "/transaction/"+row,
      method: "put",
      data: {content: $(this).attr('class')}, //'accept' or 'reject'
      dataType: 'JSON',
    });

    request.done(function(response){
      var transaction = {
        created_at: response['created_at'],
        amount: response['amount'],
        description: response['description'],
        status: response['status'],
        sender_id: response['sender_id'],
        transaction_type: response['transaction_type']
      }

      var htmlPrepend = '<tr class="row-spacing"></tr>'+'<tr><td><span class="transaction-information transaction-date">'+transaction.created_at+'</span></td>'
        + '<td><span class="transaction-information sender_id">'+transaction.transaction_type+'</span></td>'
        + '<td><span class="transaction-information description">'+transaction.description+'</span></td>'
        + '<td><span class="transaction-information status">'+transaction.status+'</span></td>'
        + '<td><span class="transaction-information amount">$'+transaction.amount+'</span></td></tr>';

      $('.transaction-row').after(htmlPrepend)
      $('#'+row).fadeOut();
    });


    request.fail(function(response){
      console.log("FAILure")
    });

  }


  var makePayment = function(form){

    var request = $.ajax({
      url: form.attr('action'),
      type: form.attr('method'),
      data: form.serialize(),
      dataType: 'JSON',
    });

    request.done(function(response){
      var table = $('.completed-transactions-table tbody');

      table.prepend(response.html);
    });

    request.fail(function(httpResponse){
      alert(httpResponse.responseText);
    });

  };

});
