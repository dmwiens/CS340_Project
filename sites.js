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


    function getSite(res, mysql, context, id, complete){
        var sql = "SELECT id, name, length, width, addr_street, addr_city, addr_state, addr_zip FROM site WHERE id = ?";
        var inserts = [id];

        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.site = results[0];
            complete();
        });
    }


    /*Display all sites. Requires web based javascript to delete sites with AJAX*/

    router.get('/', function(req, res){

        var callbackCount = 0;
        var context = {};
        context.pageTitle = "🌐 Sites";
        context.jsscripts = ["deletesite.js"];
        var mysql = req.app.get('mysql');
        getSites(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render('sites', context);
            }

        }
    });

    /* Display one site for the specific purpose of updating sites */

    router.get('/:id', function(req, res){
        
        callbackCount = 0;
        var context = {};
        context.jsscripts = ["updatesite.js"];
        var mysql = req.app.get('mysql');
        getSite(res, mysql, context, req.params.id, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render('site_update', context);
            }
        }
    });

    /* Adds a site, redirects to the sites page after adding */

    router.post('/', function(req, res){
        console.log("posted name is " + req.body.name);
        
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO site (name, length, width, addr_street, addr_city, addr_state, addr_zip) VALUES (?,?,?,?,?,?,?)";
        var inserts = [req.body.name, req.body.length, req.body.width, req.body.addr_street, req.body.addr_city, req.body.addr_state, req.body.addr_zip];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/sites');
            }
        });
    });

    /* The URI that update data is sent to in order to update a site */

    router.put('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "UPDATE site SET name=?, length=?, width=?, addr_street=?, addr_city=?, addr_state=?, addr_zip=? WHERE id=?";
        var inserts = [req.body.name, req.body.length, req.body.width, req.body.addr_street, req.body.addr_city, req.body.addr_state, req.body.addr_zip, req.params.id];
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
        var sql = "DELETE FROM site WHERE id = ?";
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