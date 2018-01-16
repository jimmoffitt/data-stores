
# MySQL

Using internal db service, connecting over ssh. Can connect 'manually' on command-line, first ssh-ing to a internal host, then connecting. When connecting via Workbench or Sequel Pro, connection attempt times out with SSH failure... Upgraded Sequel Pro version, and loaded current keys into keychain (something changed after last OS update?), and we are now good...



# Mongo

mkdir py-mongo

pip install pymongo==3.4.0

Test in python: >>> import pymongo

brew install mongodb
Error: mongodb 3.4.1 is already installed
To upgrade to 3.6.2, run `brew upgrade mongodb`




