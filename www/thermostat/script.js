var refreshTimer;
var refreshTimerDelay=10000;
var reHomeTimer;
var reHomeTimerDelay =60000;
var $calendar;
var eventDataDate=0;

function displayThermostat() {
	$("#thermostat").css("visibility", "visible");
	$("#planning").css("visibility", "hidden");
	$("#security").css("visibility", "hidden");
	$("#security").html('');

	clearInterval(refreshTimer);
	refreshTimer = setInterval(function(){RefreshData();}, refreshTimerDelay);
	clearInterval(reHomeTimer);
}

function displaySecurity() {
	$("#thermostat").css("visibility", "hidden");
	$("#planning").css("visibility", "hidden");
	$("#security").css("visibility", "visible");
	$("#security").html('<object id="obj" type="text/html" data="http://192.168.0.22:5665/secpanel/index.html" width="1008px" height="650px"></object>');
	$("#obj").css("transform", "scale(0.63)");
	$("#obj").css("transform-origin", "0% 0%");
	
	clearInterval(refreshTimer);
	clearInterval(reHomeTimer);
	reHomeTimer = setInterval(function(){displayThermostat();}, reHomeTimerDelay);
}

function buttonSelection(elmnt, onlyDisplay) {
	if (elmnt.id=="normal") {
		$("#normal").addClass("selected");
		$("#confort").removeClass("selected");
          		$("#confL").css("visibility", "hidden");
          		$("#confT").css("visibility", "hidden");				
		if ($("#absent").hasClass("selected")) {
			$("#jour").addClass("selected");
			$("#nuit").removeClass("selected");
	            	$("#consS").css("visibility", "visible");
        				$("#consC").css("visibility", "hidden");
        				$("#consA").css("visibility", "hidden");
			$("#absent").removeClass("selected");
		}
		if (onlyDisplay===undefined) {
			// Send Normal scene command to server
			callSceneSwitch($.sceneNormal);
		}
        } else if (elmnt.id=="confort") {
        	$("#normal").removeClass("selected");
		$("#confort").addClass("selected");
          	$("#confL").css("visibility", "visible");
          	$("#confT").css("visibility", "visible");				
		if ($("#absent").hasClass("selected")) {
			$("#jour").addClass("selected");
			$("#nuit").removeClass("selected");
          		$("#consS").css("visibility", "visible");
    	    		$("#consC").css("visibility", "hidden");
        		$("#consA").css("visibility", "hidden");
			$("#absent").removeClass("selected");
		}
		if (onlyDisplay===undefined) {
			// Send Confort scene command to server
			callSceneSwitch($.sceneConfor);
		}
        } else if (elmnt.id=="jour") {
        	$("#sonde1").css("visibility", "visible");
        	$("#sonde2").css("visibility", "hidden");
        	$("#tempS").css("visibility", "visible");
        	$("#tempC").css("visibility", "hidden");
		if (!$("#absent").hasClass("selected")) {
			$("#jour").addClass("selected");
			$("#nuit").removeClass("selected");
          		$("#consS").css("visibility", "visible");
    	    		$("#consC").css("visibility", "hidden");
        		$("#consA").css("visibility", "hidden");
		}
		if (onlyDisplay===undefined) {
			// Send Derogation Jour scene command to server
			callSceneSwitch($.sceneDerogJ);
		}
	} else if (elmnt.id=="nuit") {
		$("#sonde1").css("visibility", "hidden");
        	$("#sonde2").css("visibility", "visible");
        	$("#tempS").css("visibility", "hidden");
        	$("#tempC").css("visibility", "visible");
		if (!$("#absent").hasClass("selected")) {
			$("#jour").removeClass("selected");
			$("#nuit").addClass("selected");
          		$("#consS").css("visibility", "hidden");
    	    		$("#consC").css("visibility", "visible");
        		$("#consA").css("visibility", "hidden");
		}
		if (onlyDisplay===undefined) {
			// Send Derogatino Nuit scene command to server
			callSceneSwitch($.sceneDerogN);
		}
	} else if (elmnt.id=="absent") {
        	$("#normal").removeClass("selected");
		$("#confort").removeClass("selected");
		$("#jour").removeClass("selected");
		$("#nuit").removeClass("selected");
		$("#absent").addClass("selected");
		$("#consS").css("visibility", "hidden");
        	$("#consC").css("visibility", "hidden");
        	$("#consA").css("visibility", "visible");
		if (onlyDisplay===undefined) {
			// Send Absent scene command to server
			callSceneSwitch($.sceneAbsent);
		}
	}
}
		
function callSceneSwitch(scene) {
	var jurl=$.domoticzurl+"/json.htm?type=command&param=switchscene&idx="+scene+"&switchcmd=On";
	$.getJSON(jurl, {format: "json"});
}
		
function processJSONData(data, tab) {
	if (typeof data.result != 'undefined') {
		$.each(data.result, function(i,item){
			for( var ii = 0, len = tab.length; ii < len; ii++ ) {
				if( tab[ii][0] === item.idx ) {
					var vtype=tab[ii][1];
					var vlabel=tab[ii][2];
					var vdata=item[vtype];
					if (vdata === undefined) {
						vdata="??";
					} else {
						vdata=new String(vdata).split(" ",1)[0];
					}
					$('#'+vlabel).html(vdata);
				}
			}
		});
	}
}
		
function RefreshData() {
	// Get Domoticz devices statuses and values
	var jurl=$.domoticzurl+"/json.htm?type=devices&plan="+$.roomplan+"&lastupdate="+$.LastUpdateTime+"&jsoncallback=?";
	$.getJSON(jurl,
		{format: "json"},
		function(data) {
			if (typeof data.ActTime != 'undefined') {
				$.LastUpdateTime=parseInt(data.ActTime);
			}
			processJSONData(data,$.PageArray1);
		});
	// Get Domoticz user variables	
	var jurl2=$.domoticzurl+"/json.htm?type=command&param=getuservariables&jsoncallback=?";
	$.getJSON(jurl2,
		{format: "json"},
		function(data) {
			processJSONData(data,$.PageArray2);
		});
	// Hide div that should stay invisible
	$("#planC").css("visibility", "hidden");
	$("#confP").css("visibility", "hidden");
	$("#abseT").css("visibility", "hidden");
	
	// Update buttons according retrieved values
	if ($('#abseT').html()=="On") {
		buttonSelection(document.getElementById("absent"), true);
	} else {
		if ($('#confP').html()=="Off") {
			buttonSelection(document.getElementById("normal"), true);
		} else {
			buttonSelection(document.getElementById("confort"), true);
		}
	}
	if ($('#planC').html()=="On") {
		buttonSelection(document.getElementById("jour"), true);
	} else {
		buttonSelection(document.getElementById("nuit"), true);
	}
}

$(document).ready(function() {
	$.LastUpdateTime=parseInt(0);
	$.domoticzurl="http://192.168.0.22:5665";
	$.sceneNormal=1;
	$.sceneConfor=2;
	$.sceneDerogJ=4;
	$.sceneDerogN=5;
	$.sceneAbsent=3;
	$.roomplan=7;
	//format: idx, value, label, comment
	$.PageArray1 = [
		['6', 'Temp','tempS','temperature salon'],
		['16','Temp','tempC','temperature chambre'],
		['25','Status','planC','planning chaudiere'],
		['21','Status','confP','confortPlus  inter'],
		['31','Status','abseT','absence      inter'],
	];
	$.PageArray2 = [
		['4', 'Value','consS','consigne salon'],
		['5', 'Value','consC','consigne chambre'],
		['11','Value','consA','consigne absent'],
		['7', 'Value','confT','consigne confort'],
	];
	RefreshData();
	refreshTimer = setInterval(function(){RefreshData();}, refreshTimerDelay);

	// Avoid scrolling
	window.addEventListener("touchmove", function(event){
                event.preventDefault();
	},false);
	window.addEventListener("scroll",function(){
    		window.scrollTo(0,0);
	},false);
});
