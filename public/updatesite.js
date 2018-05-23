function updateSite(id){
    $.ajax({
        url: '/sites/' + id,
        type: 'PUT',
        data: $('#site_update_form').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};