$db = $.couch.db("sofea_test");
var evaluations_so_far;
//--------------------------------------------------------------
function reproduce (data) {
    var after_eval = new Array;
    if (data.rows.length == 0 ) {
	alert('No data');
        setTimeout('check_evaluations()',1000);
    } else {
	var pool = get_pool_roulette_wheel( data.rows, 32 );
	var new_population = produce_offspring( pool, 32 );
	$("div#chromosomes").html('');
	for ( var i in new_population ) {
	    $("div#chromosomes").append( cool_chrom( new_population[i]._id));
	}
	$db .bulkSave({"docs": new_population}, {
	    success: function(data) {
		console.log(data);
	    },
	    error: function(status) {
		console.log(status);
            }
	});
    }
    check_evaluations();
       
}
//--------------------------------------------------------------
function check_evaluations () {
    $db.view("docs/count", {
	success: function(data) {
	    evaluations_so_far = data.rows[0].value;
	    if ( evaluations_so_far < 5000 ) {
	        repro_chromosomes();
	    } else {
		alert("It's over");
	    }
	}
    } );
}

//--------------------------------------------------------------
function repro_chromosomes() {  
    $db.view("rev/rev2", {  
	success: reproduce,
	startkey: Math.random(),
	limit: 32});
}

//------------------------------------------------
   
$(document).ready(function() {
    check_evaluations();
});