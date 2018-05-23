function deleteAccess(id){
   $.ajax({
        url: '/accesses/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};