function updateAccess(id){
    $.ajax({
        url: '/accesses/' + id,
        type: 'PUT',
        data: $('#access_update_form').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};