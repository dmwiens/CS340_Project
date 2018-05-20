var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs340_wiensda',
  password        : '2179',
  database        : 'cs340_wiensda'
});

module.exports.pool = pool;