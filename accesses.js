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

    
    function getAccesses(res, mysql, context, complete){
        mysql.pool.query("SELECT GS.id, GS.gardener, GS.site, G.id AS gid, G.fname, G.lname, S.id AS sid, S.name FROM `gardener_site` GS INNER JOIN gardener G ON G.id = GS.gardener INNER JOIN site S ON S.id = GS.site", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.accesses = results;
            complete();
        });
    }


    function getAccess(res, mysql, context, id, complete){
        var sql = "SELECT id, gardener, site FROM gardener_site WHERE id = ?";
        var inserts = [id];

        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.access = results[0];
            complete();
        });
    }


    /*Display all accesses. Requires web based javascript to delete accesses with AJAX*/

    router.get('/', function(req, res){

        var callbackCount = 0;
        var context = {};
        context.pageTitle = "🔑 Accesses";
        context.jsscripts = ["deleteaccess.js"];
        var mysql = req.app.get('mysql');
        getGardeners(res, mysql, context, complete);
        getSites(res, mysql, context, complete);
        getAccesses(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 3){
                res.render('accesses', context);
            }

        }
    });

    /* Display one site for the specific purpose of updating sites */

    router.get('/:id', function(req, res){
        
        callbackCount = 0;
        var context = {};
        context.jsscripts = ["updateaccess.js",  "selectgardenersite.js"];
        var mysql = req.app.get('mysql');
        getGardeners(res, mysql, context, complete);
        getSites(res, mysql, context, complete);
        getAccess(res, mysql, context, req.params.id, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 3){
                res.render('access_update', context);
            }
        }
    });


    /* Adds a site, redirects to the accesses page after adding */

    router.post('/', function(req, res){
        
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO gardener_site (gardener, site) VALUES (?,?)";
        var inserts = [req.body.gardener, req.body.site];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/accesses');
            }
        });
    });

    /* The URI that update data is sent to in order to update an access */

    router.put('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "UPDATE gardener_site SET gardener=?, site=? WHERE id=?";
        var inserts = [req.body.gardener, req.body.site, req.params.id];
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

    /* Route to delete a site, simply returns a 202 upon success. Ajax will handle this. */

    router.delete('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "DELETE FROM gardener_site WHERE id = ?";
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