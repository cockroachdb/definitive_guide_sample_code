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

CREATE DATABASE CHAPTER13;
USE CHAPTER13;

DROP VIEW restricted_documents_view;

DROP TABLE IF EXISTS documents;

DROP TABLE IF EXISTS document_access;

CREATE TABLE documents (
	id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	description varchar(100),
	document text,
	security_restriction varchar(20) default('OPEN')
);

INSERT INTO documents (description, security_restriction) 
 values('Ben Darnell - the inside story','TOP SECRET'),
       ('MongoDB - plans for their destruction', 'SECRET'),
       ('Why CockroachDB is better than Oracle', 'OPEN');
       
SELECT description, security_restriction FROM documents;

CREATE TABLE document_access(
	username varchar(80),
	security_access varchar(20)
);

DELETE FROM document_access;

INSERT INTO document_access (username, security_access)
 VALUES ('ben','TOP SECRET'),('ben','SECRET'),('jesse','SECRET'),('root','SECRET');

SELECT * FROM document_access;

CREATE VIEW restricted_documents_view AS
SELECT id,description,document FROM documents 
 WHERE security_restriction='OPEN'
 UNION 
 SELECT d.id, d.description,d.document 
   FROM documents d JOIN document_access da 
     ON(d.security_restriction=da.security_access)
  WHERE da.username=current_user;
 
GRANT SELECT ON document_access TO PUBLIC;
   
SELECT * FROM restricted_documents_view; 

SELECT d.id, d.description,da.security_access 
  FROM documents d    
 

