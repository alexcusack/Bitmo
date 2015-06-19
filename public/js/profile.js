$(document).ready(function() {

  // bind pay button
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

});



// make a payment
var makePayment = function(){
  var action = $('.create-transaction').attr('action');
  var method = $('.create-transaction').attr('method');
  var toPerson = $('.to-field').val()
  var amount = $('.amount-field').val()
  var description = $('.description-field').val()

  var request = $.ajax({
      url: action,
      type: method,
      data: {to: toPerson,
             amount: amount,
             description: description,
             transaction_type: transactionType,
            },
      dataType: 'JSON'
    });


  request.done(function(response){
    console.log("you're in the request done!");
    var transaction = {
      created_at: response['created_at'],
      amount: response['amount'],
      description: response['description'],
      status: response['status'],
      sender_id: response['sender_id'],
    }

    var htmlPrepend = '<tr><td><span class="transaction-information transaction-date">'+transaction.created_at+'</span></td>'
      + '<td><span class="transaction-information sender_id">'+transaction.sender_id+'</span></td>'
      + '<td><span class="transaction-information description">'+transaction.description+'</span></td>'
      + '<td><span class="transaction-information status">'+transaction.status+'</span></td>'
      + '<td><span class="transaction-information amount">'+transaction.amount+'</span></td></tr>';

    $('.transaction-row').prepend(htmlPrepend)
  })




};





// make a charge
var makeCharge = function(){
  var action = $('.create-transaction').attr('action');
  var method = $('.create-transaction').attr('method');
  var toPerson = $('.to-field').val()
  var amount = $('.amount-field').val()
  var description = $('.description-field').val()
};
