queries = SQL queries
results = where the results of the SQL queries are stored. Use the .tsv format. (the wiki says .csv but it's broken)

i've been using commands, such as the sample query below on ATTU to get .tsv files, which i then use for data analytics. been using excel, but could probably automate with python or some other language.

Sample query:
mysql -hdev.db.centerforgamescience.com -ugc_alarmclock -p -D cgs_gc_18sp_alarmclock_log < queries/SOMEQUERYHERE.sql > results/SOMEOUTPUTNAME.tsv
