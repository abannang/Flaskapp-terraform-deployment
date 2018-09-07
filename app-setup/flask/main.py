from flask import Flask
import sys
import MySQLdb
import memcache
import time

app = Flask(__name__)


@app.route('/')
def index():
	memc = memcache.Client(['127.0.0.1:11211'], debug=1);

	try:
	    conn = MySQLdb.connect (host = "localhost",
	                            user = "sakila",
	                            passwd = "password",
	                            db = "sakila")
	except MySQLdb.Error, e:
	     return "Error %d: %s" % (e.args[0], e.args[1])
	     sys.exit (1)

	popularfilms = memc.get('top5films')

	if not popularfilms:
	    cursor = conn.cursor()
	    cursor.execute('select film_id,title from film order by rental_rate desc limit 5')
	    rows = cursor.fetchall()
	    memc.set('top5films',rows,60)
	    return "Updated memcached with MySQL data"
	else:
	    return "Loaded data from memcached"
	    for row in popularfilms:
	        return "%s, %s" % (row[0], row[1])

if __name__ == "__main__":
	app.run(host='0.0.0.0',port=8080)