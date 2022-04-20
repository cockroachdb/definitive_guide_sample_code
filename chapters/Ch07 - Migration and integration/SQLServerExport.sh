sqlcmd -U SA -P Jagat@2016 -d AdventureWorks2019 \
 -Q 'SELECT * FROM HumanResources.Employee' \
 -W -w 1024 -s”,”