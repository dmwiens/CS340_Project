function updateWorkshift(id){
    $.ajax({
        url: '/workshifts/' + id,
        type: 'PUT',
        data: $('#workshift_update_form').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};