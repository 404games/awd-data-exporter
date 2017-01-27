=================
Awd data exporter
=================
Command line tool to export awd data to config files (currently coffeescript files).
The tool read sequencally the awd files in source-awds/, parse them and then export the name, location, rotation and scaling of each mesh into a coffee file and save it to dest-coffees/.

Feel free to edit the source code to adapt it to your needs.

I left input/ouput example in source-awds/test.awd and dest-coffees/test.coffee.

get started
============
- install adobe air v20 (older version should also work)
- make
- move awd file(s) you want to export in source-awds/
- make run (check your log to see export progress)


Commands
========

``make``     = compile flash sources to build/

``make run`` = starts the script
