<?php

function newSession() {
	$con = mysqli_connect("localhost", "root", "root");
	if ($con) {
		mysqli_select_db($con, "appserver");

		
		$result = $con->query("SELECT max(sessionID) from sessions");

		$row = $result->fetch_array();
		$maxsession = $row[0];
		$newsession = $maxsession+1;

		if ($con->query("INSERT INTO sessions(sessionID) VALUES(".$newsession.")")) {
			echo $newsession;
		}
		else {
			echo $con->error;
		}
	}

	$con->close();
}

function addPlayerToSession($sessionid) {
	$con = mysqli_connect("localhost", "root", "root");
	$newUserID = -1;


	if ($con) {
		mysqli_select_db($con, "appserver");

		$stmt = $con->prepare("SELECT sessionID, userID FROM sessions WHERE sessionID = (?)");
		$stmt->bind_param("i", $sessionid);
		$stmt->execute();
		$stmt->bind_result($sessionID, $userID);

		    /* fetch values */
    	while ($stmt->fetch()) {
        	//printf("%d %d\n", $sessionID, $userID);
    	}
    	$newUserID = $userID + 1;
    	
    	$stmt = $con->prepare("INSERT INTO sessions(sessionID, userID) VALUES (?,?)");
		$stmt->bind_param("ii", $sessionid, $newUserID);
		$stmt->execute();

   		$stmt->close();
	}
	echo $newUserID;
}


if (!isset($_GET["action"]))
{
	echo "No action specified";
	exit;
}

$action = $_GET["action"];
if ($action == "newsession") {
	newSession();
}
else if ($action == "addplayer") {
	if (!isset($_GET["sessionid"]))
	{
		echo "sessionid is not set";
		exit;
	}

	$sessionid = (int)$_GET["sessionid"];
	addPlayerToSession($sessionid);
}
else {
	echo "invalid action";
	exit;
}



?>