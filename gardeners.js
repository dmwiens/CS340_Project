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

    /*
    function getPlanets(res, mysql, context, complete){
        mysql.pool.query("SELECT id, name FROM bsg_planets", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.planets  = results;
            complete();
        });
    }


    */

    function getGardener(res, mysql, context, id, complete){
        var sql = "SELECT id, fname, lname FROM gardener WHERE id = ?";
        var inserts = [id];

        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.gardener = results[0];
            complete();
        });
    }


    /*Display all gardeners. Requires web based javascript to delete users with AJAX*/

    router.get('/', function(req, res){
        
        /*
        var context = {};
        context.pageTitle = "👨‍🌾 Gardenersasdf";
        res.render('gardeners', context);

        */
        var callbackCount = 0;
        var context = {};
        context.pageTitle = "👨‍🌾 Gardeners";
        context.jsscripts = ["deletegardener.js"];
        //context.jsscripts = ["deleteperson.js"];
        var mysql = req.app.get('mysql');
        getGardeners(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render('gardeners', context);
            }

        }
    });

    /* Display one gardener for the specific purpose of updating gardeners */

    router.get('/:id', function(req, res){
        
        callbackCount = 0;
        var context = {};
        context.jsscripts = ["updategardener.js"];
        var mysql = req.app.get('mysql');
        getGardener(res, mysql, context, req.params.id, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render('gardener_update', context);
            }
        }
    });

    /* Adds a gardener, redirects to the people page after adding */

    router.post('/', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO gardener (fname, lname) VALUES (?,?)";
        var inserts = [req.body.fname, req.body.lname];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/gardeners');
            }
        });
    });

    /* The URI that update data is sent to in order to update a gardener */

    router.put('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "UPDATE gardener SET fname=?, lname=? WHERE id=?";
        var inserts = [req.body.fname, req.body.lname, req.params.id];
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

    /* Route to delete a person, simply returns a 202 upon success. Ajax will handle this. */

    router.delete('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "DELETE FROM gardener WHERE id = ?";
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