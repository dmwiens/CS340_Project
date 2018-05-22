function updateGardener(id){
    $.ajax({
        url: '/gardeners/' + id,
        type: 'PUT',
        data: $('#gardener_update_form').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};