$(document).ready(function() {

  // bind pay button
  $('#pay').on('click', function(event){
   event.preventDefault;
   alert('pay caught')
  });

  $('#charge').on('click', function(event){
   event.preventDefault;
   alert('charge caught')

  });

});



// make a payment
var makePayment = function(){
  var action = $('.create-transaction').attr('action');
  var method = $('.create-transaction').attr('method');
  var toPerson = $('.to-field').val()
  var amount = $('.amount-field').val()
  var description = $('.description-field').val()
};





// make a charge
var makeCharge = function(){
  var action = $('.create-transaction').attr('action');
  var method = $('.create-transaction').attr('method');
  var toPerson = $('.to-field').val()
  var amount = $('.amount-field').val()
  var description = $('.description-field').val()
};
