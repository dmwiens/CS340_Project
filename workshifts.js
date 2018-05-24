module.exports = function(){
    var express = require('express');
    var router = express.Router();


    function getGardeners(res, mysql, context, complete){
        mysql.pool.query("SELECT id, fname, lname FROM gardener", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.gardeners = results;
            complete();
        });
    }


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

    
    function getWorkshifts(res, mysql, context, complete){
        mysql.pool.query("SELECT W.id, W.gardener, W.site, W.date, W.hours_worked,\
                        G.id AS gid, G.fname, G.lname, S.id AS sid, S.name \
                        FROM `workshift` W \
                        INNER JOIN gardener G ON G.id = W.gardener \
                        INNER JOIN site S ON S.id = W.site", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.workshifts = results;
            complete();
        });
    }


    function getWorkshift(res, mysql, context, id, complete){
        var sql = "SELECT id, gardener, site FROM workshift WHERE id = ?";
        var inserts = [id];

        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.workshift = results[0];
            complete();
        });
    }


    /*Display all workshifts. Requires web based javascript to delete workshift with AJAX*/

    router.get('/', function(req, res){

        var callbackCount = 0;
        var context = {};
        context.pageTitle = "⏱ Workshifts";
        context.jsscripts = ["deleteworkshift.js"];
        var mysql = req.app.get('mysql');
        getGardeners(res, mysql, context, complete);
        getSites(res, mysql, context, complete);
        getWorkshifts(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 3){
                res.render('workshifts', context);
            }

        }
    });

    /* Display one workshift for the specific purpose of updating workshifts */

    router.get('/:id', function(req, res){
        
        callbackCount = 0;
        var context = {};
        context.jsscripts = ["updateworkshift.js",  "selectwsgardenersite.js"];
        var mysql = req.app.get('mysql');
        getGardeners(res, mysql, context, complete);
        getSites(res, mysql, context, complete);
        getWorkshift(res, mysql, context, req.params.id, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 3){
                res.render('workshift_update', context);
            }
        }
    });


    /* Adds a workshift, redirects to the workshifts page after adding */

    router.post('/', function(req, res){
        
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO workshift (gardener, site, date, hours_worked) VALUES (?,?,?,?)";
        var inserts = [req.body.gardener, req.body.site, req.body.date, req.body.hours_worked];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/workshifts');
            }
        });
    });

    /* The URI that update data is sent to in order to update an workshift */

    router.put('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "UPDATE workshift SET gardener=?, site=?, date=?, hours_worked=? WHERE id=?";
        var inserts = [req.body.gardener, req.body.site, req.body.date, req.body.hours_worked, req.params.id];
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

    /* Route to delete a workshift, simply returns a 202 upon success. Ajax will handle this. */

    router.delete('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "DELETE FROM workshift WHERE id = ?";
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