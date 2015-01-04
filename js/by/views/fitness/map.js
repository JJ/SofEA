function(doc) {
    var rev = doc._rev.split("-");
    if (  (rev[0] == '2') && ('fitness' in doc)  ) 
      	emit( doc.fitness, doc);	
}