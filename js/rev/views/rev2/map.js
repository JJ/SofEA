 function(doc) {
     var rev = doc._rev.split("-");
     if (  rev[0] == '2') 
      	 emit( doc.rnd, doc);	
 }