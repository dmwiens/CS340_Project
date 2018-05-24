function updateBed(id){
    $.ajax({
        url: '/beds/' + id,
        type: 'PUT',
        data: $('#bed_update_form').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};