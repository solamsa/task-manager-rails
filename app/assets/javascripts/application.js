// //= require jquery3
// //= require_tree
// $(document).ready(function() {
//   $('#status_select').change(function() {
//     var status = $(this).val();
//     console.log(status)
//     $.ajax({
//       url: '/tasks', // Change this to the appropriate route
//       method: 'GET',
//       data: { status: status },
//       success: function(response) {
//         $('#table-container').html(response);
//       }
//     });
//   });
// });