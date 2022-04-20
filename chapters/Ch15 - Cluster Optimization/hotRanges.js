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

analyse the output from the hotranges dump 

*/
const fs = require('fs');

async function main() {
    const unsortedRanges=[];
    let ranges = await fs.readFileSync('hotranges.json','utf8');
    let rangeJson=JSON.parse(ranges);
    Object.keys(rangeJson.hotRangesByNodeId).forEach((node)=>{
        let hotRanges=rangeJson.hotRangesByNodeId[node];
        hotRanges.stores.forEach((store)=>{
            store.hotRanges.forEach((range)=>{
                unsortedRanges.push({node,storeId:store.storeId,rangeId:range.desc.rangeId,queriesPerSecond:range.queriesPerSecond});
            });
        });
    });
    unsortedRanges.sort((a, b) => a.queriesPerSecond > b.queriesPerSecond && -1 || 1);
    for (let ic=0;ic<10;ic++)
        console.log(unsortedRanges[ic]);
}

main();
