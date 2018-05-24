module.exports = function(){
    var express = require('express');
    var router = express.Router();


    function getSites(res, mysql, context, complete){
        mysql.pool.query("SELECT id, name, length, width, addr_street, addr_city, addr_state, addr_zip FROM site", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.sites = results;
            complete();
        });
    }

    function getBeds(res, mysql, context, complete){
        mysql.pool.query("SELECT B.id, B.bname, B.site, S.name AS sname, B.blength, B.bwidth, B.location_x, B.location_y FROM bed B \
                        INNER JOIN site S ON B.site = S.id", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.beds = results;
            complete();
        });
    }


    function getBed(res, mysql, context, id, complete){
        var sql = "SELECT id, bname, site, blength, bwidth, location_x, location_y FROM bed WHERE id = ?";
        var inserts = [id];

        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.bed = results[0];
            complete();
        });
    }


    /*Display all beds. Requires web based javascript to delete beds with AJAX*/

    router.get('/', function(req, res){

        var callbackCount = 0;
        var context = {};
        context.pageTitle = "🌱 Garden Beds";
        context.jsscripts = ["deletebed.js"];
        var mysql = req.app.get('mysql');
        getBeds(res, mysql, context, complete);
        getSites(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 2){
                res.render('beds', context);
            }

        }
    });

    /* Display one bed for the specific purpose of updating beds */

    router.get('/:id', function(req, res){
        
        callbackCount = 0;
        var context = {};
        context.jsscripts = ["updatebed.js", "selectbedsite.js"];
        var mysql = req.app.get('mysql');
        getBed(res, mysql, context, req.params.id, complete);
        getSites(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 2){
                console.log(context);
                res.render('bed_update', context);
            }
        }
    });

    /* Adds a bed, redirects to the beds page after adding */

    router.post('/', function(req, res){
        
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO bed (bname, site, blength, bwidth, location_x, location_y) VALUES (?,?,?,?,?,?)";
        var inserts = [req.body.bname, req.body.site, req.body.blength, req.body.bwidth, req.body.location_x, req.body.location_y];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/beds');
            }
        });
    });

    /* The URI that update data is sent to in order to update a bed */

    router.put('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "UPDATE bed SET bname=?, site=?, blength=?, bwidth=?, location_x=?, location_y=? WHERE id=?";
        var inserts = [req.body.bname, req.body.site, req.body.blength, req.body.bwidth, req.body.location_x, req.body.location_y, req.params.id];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.status(200);
                res.end();
            }
        });
    });

    /* Route to delete a bed, simply returns a 202 upon success. Ajax will handle this. */

    router.delete('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "DELETE FROM bed WHERE id = ?";
        var inserts = [req.params.id];
        sql = mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.status(400);
                res.end();
            }else{
                res.status(202).end();
            }
        })
    })

    return router;
}();