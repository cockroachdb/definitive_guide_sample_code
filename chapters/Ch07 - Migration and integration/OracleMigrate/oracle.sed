s/VARCHAR2(.*)/VARCHAR/g
s/NUMBER(.*,0)/INT/g
s/NUMBER(.*,.*)/FLOAT/g
s/NUMBER/FLOAT/g
s/USING INDEX (.*) ENABLE//g
#s/USING INDEX //g
#s/ENABLE//g
s/\"(.*)\"\.//g