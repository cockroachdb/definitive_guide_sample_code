/* 
CockroachDB the Definitive Guide sample code 
This code  is public domain software, i.e. not copyrighted.

Warranty Exclusion
------------------
You agree that this software is a non-commercially developed program that may 
contain "bugs"   and that it may not function as intended.
The software is licensed "as is". The authors make no, and hereby expressly
disclaim all, warranties, express, implied, statutory, or otherwise
with respect to the software, including noninfringement and the implied
warranties of merchantability and fitness for a particular purpose.

@author:  gharriso (guy.a.harrison@gmail.com)
*/

SET CLUSTER SETTING cloudstorage.gs.default.key = '{
  "type": "service_account",
  "project_id": "ghreqs",
  "private_key_id": "048d8 Blah blah eef9fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANB SORRY I CANT SHARE THIS ykfy5cPMvVixA9etdg==\n-----END PRIVATE KEY-----\n",
  "client_email": "592053976296-compute@developer.gserviceaccount.com",
  "client_id": "112395942388993483786",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/592053976296-compute%40developer.gserviceaccount.com"
}';
BACKUP INTO 'gs://ghcrdb/full.backup' ;


backup database bank into 'gs://ghcrdb/bank.backup' ;

backup database bank into 'userfile://bank.backup/';

BACKUP INTO 'gs://ghcrdb/full.backup' ;

BACKUP INTO 'nodelocal://1/onehourago.backup/' AS OF SYSTEM TIME '-1h';

BACKUP INTO 'nodelocal://1/fullClusterBackup/';

SHOW BACKUPS IN 'nodelocal://1/fullClusterBackup/';

BACKUP TABLE movr.rides, movr.users INTO 'nodelocal://1/movr.rides.backup/';

BACKUP DATABASE movr INTO 'nodelocal://1/movr.full.backup/';
