function deleteGardener(id){
   $.ajax({
        url: '/gardeners/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};