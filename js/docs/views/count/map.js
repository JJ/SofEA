function(doc) {
    var rev = doc._rev.split("-");
    if ( rev[0].match(/[23]/) )
	emit(doc._id, 1);
}