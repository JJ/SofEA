function(doc) {
    var rev = doc._rev.split("-");
    if (  (rev[0] == '1') && ('fitness' in doc)  ) 
      	emit( doc.fitness, doc);	
}