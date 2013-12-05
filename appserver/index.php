<?php

$con = mysqli_connect("localhost", "root", "root") or die("Unable to connect to db.");
$con->select_db("appserver");
	

function newSession() {
	global $con;

	$result = $con->query("SELECT max(sessionID) from sessions");
	$row = $result->fetch_array();
	$maxsession = $row[0];
	$newsession = $maxsession+1;

	if ($con->query("INSERT INTO sessions(sessionID) VALUES(".$newsession.")")) {
		$con->close();
		return $newsession;
	}
	else {
		echo $con->error;
		$con->close();
	}
	return -1;
}

function addPlayerToSession($sessionid) {
	global $con;

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

	return $newUserID;
}


function getNumberOfPlayersInSession($sessionid)
{
	global $con;

	$stmt = $con->prepare("SELECT count(*) FROM sessions WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionid);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
	}
	$stmt->close();
	return $result-1; // minus player 0
}




if (!isset($_GET["action"]))
{
	echo "No action specified";
	exit;
}

$action = $_GET["action"];
switch ($action)
{
	case "newsession": {
		echo newSession();
		break;
	}
	case "addplayer": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		echo addPlayerToSession($sessionid);
		break;
	}
	case "getnumberofplayers": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		echo getNumberOfPlayersInSession($sessionid);
		break;
	}
	default: {
		echo "invalid action";
		exit;
	}
}



?>