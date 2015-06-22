$(document).ready(function() {

  $('#pay').on('click', function(event){
    event.preventDefault();
    console.log('pay caught')
    transactionType= "Pay"
    makePayment();
  });

  $('#charge').on('click', function(event){
    event.preventDefault();
    console.log('charge caught')
    transactionType= "Charge"
    makePayment();
  });

  $('.accept').on('click', function(event){
    event.preventDefault();
    console.log('caught accept')
    approve.call(this);
  })

  $('.reject').on('click', function(event){
    event.preventDefault();
    console.log('caught accept')
    approve.call(this);
  })


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
      // var table;
      // if (response.pending){
      //   table = $('.pending-transactions-table');
      // }else{
      //   table = $('.completed-transactions-table');
      // }
      // debugger
      // table.append(response.html);

      // var transaction = {
      //   created_at: response['created_at'],
      //   amount: response['amount'],
      //   description: response['description'],
      //   status: response['status'],
      //   sender_id: response['sender_id'],
      //   transaction_type: response['transaction_type']
      // }

      // var htmlPrepend = '<tr class="row-spacing"></tr>'+'<tr><td><span class="transaction-information transaction-date">'+transaction.created_at+'</span></td>'
      //   + '<td><span class="transaction-information sender_id">'+transaction.transaction_type+'</span></td>'
      //   + '<td><span class="transaction-information description">'+transaction.description+'</span></td>'
      //   + '<td><span class="transaction-information status">'+transaction.status+'</span></td>'
      //   + '<td><span class="transaction-information amount">$'+transaction.amount+'</span></td></tr>';

      // $('.transaction-row').after(htmlPrepend)
      // $('#'+row).fadeOut();
    });


    request.fail(function(response){
      console.log("FAILure")
    });

  }


  var makePayment = function(){

    var request = $.ajax({
      url: $('.create-transaction').attr('action'),
      type: $('.create-transaction').attr('method'),
      data: {
        to: $('.to-field').val(),
        amount: $('.amount-field').val(),
        description: $('.description-field').val(),
        transaction_type: transactionType,
      },
      dataType: 'JSON',
    });

    request.done(function(response){
      var table;
      if (response.pending){
        table = $('.pending-transactions-table tbody');
      }else{
        table = $('.completed-transactions-table tbody');
      }
      table.prepend(response.html);
    });

    request.fail(function(httpResponse){
      alert(httpResponse.responseText);
    });

  };

}); //end doc ready
