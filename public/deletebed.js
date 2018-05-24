function deleteBed(id){
   $.ajax({
        url: '/beds/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};