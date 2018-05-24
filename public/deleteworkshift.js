function deleteWorkshift(id){
   $.ajax({
        url: '/workshifts/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};