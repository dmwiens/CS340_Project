function deleteSite(id){
   $.ajax({
        url: '/sites/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};