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


    function getSite(res, mysql, context, siteId, complete){
        var sql = "SELECT id, name, length, width, addr_street, addr_city, addr_state, addr_zip FROM site WHERE id = ?";
        var inserts = [siteId];

        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.site = results[0];
            complete();
        });
    }


    function getBedsOnSite(res, mysql, context, siteId, complete){
        console.log("site ID in getBedsOnSite: "+ siteId);
        var sql = "SELECT B.id, B.name, B.site, S.name AS sname, B.length, B.width, B.location_x, B.location_y FROM bed B \
                    INNER JOIN site S ON B.site = S.id WHERE B.site = ?";
        var inserts = [siteId];
        
        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.beds = results;
            complete();
        });
    }


    /*Display a form that allows use to select a site to map. */

    router.get('/', function(req, res){
        
        var callbackCount = 0;
        var context = {};
        context.pageTitle = "🔭 Bed Map";
        context.jsscripts = [];
        var mysql = req.app.get('mysql');
        getSites(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render('bedmap_select', context);
            }

        }
    });


    /* Draws the Site of the posted Site id */

    router.post('/', function(req, res){
        callbackCount = 0;
        var context = {};
        context.jsscripts = ["drawbedmap.js"];
        var mysql = req.app.get('mysql');
        getBedsOnSite(res, mysql, context, req.body.site, complete);
        getSite(res, mysql, context, req.body.site, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 2){
                res.render('bedmap_draw', context);
            }
        }
    });

    return router;
}();