 function(doc) {
      var rev = doc._rev.split("-");
	if ( rev[0] == '1' ) 
      		emit( doc.rnd, doc);	
    }