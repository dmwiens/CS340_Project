function deleteGardener(id){
    console.log('Deleted gardener ' + id)
   $.ajax({
        url: '/gardeners/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};