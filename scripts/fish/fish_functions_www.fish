
# FISH SHELL SCRIPT


# Utility functions for web developers

###
# Change dir to web root
##
function www
  cd $DOCUMENT_ROOT
end

###
# Dump a MySQL database.
#
# $argv[1] string name of the database
##
function dumpdb
  if [ $argv[1] ]
    set dbfilename (pwd)/$argv[1]_(date "+%F_%H%M%S").sql.gz
    mysqldump -u root -p $argv[1] | gzip -9 > $dbfilename ; echo Dumped $argv[1] to $dbfilename;
  end
end
