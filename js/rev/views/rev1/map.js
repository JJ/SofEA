 function(doc) {
     if ( doc._id != "solution" ) { // used for special docs
	 var rev = doc._rev.split("-");
	 if ( rev[0] == '1' ) 
      	     emit( doc.rnd, doc);	
     }
 }