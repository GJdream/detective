<?php

$con = mysqli_connect("localhost", "root", "") or die("Unable to connect to db.");
$con->select_db("appserver");
	

function newSession() {
	global $con;

	// get latest id
	$result = $con->query("SELECT max(sessionID) from sessions");
	$row = $result->fetch_array();
	$maxsession = $row[0];

	// insert new id which is 
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

function addPlayerToSession($sessionID) {
	global $con;

	$result = $con->query("SELECT max(playerID) FROM sessionsInPlay WHERE sessionID = ".$sessionID);
	$row = $result->fetch_array();
	$maxPlayerID = $row[0];

	if ($maxPlayerID == null) {
		$newPlayerID = 0;
	}
	else {
		$newPlayerID = $maxPlayerID+1;
	}

	if ($con->query("INSERT INTO sessionsInPlay(sessionID, playerID) VALUES(".$sessionID.",".$newPlayerID.")")) {
		$con->close();
		return $newPlayerID;
	}
	else {
		echo $con->error;
		$con->close();
	}


	
	return $newPlayerID;
}


function getNumberOfPlayersInSession($sessionid)
{
	global $con;

	$stmt = $con->prepare("SELECT count(*) FROM sessionsInPlay WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionid);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
    }

	$stmt->close();
	return $result;
}


function getPlayerDataAsJSON($sessionid)
{
	global $con;

	$stmt = $con->prepare("SELECT playerID, playerName, playerImage, playerRole, playerAlive FROM sessionsInPlay WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionid);
	$stmt->execute();
	$result = $stmt->get_result();

	while ($row = $result->fetch_assoc()) {
		$row_result[] = array(
			'playerID' => (int)$row['playerID'],
			'playerName' => $row['playerName'],
			'playerImage' => $row['playerImage'],
			'playerRole' => $row['playerRole'],
			'playerAlive' => (bool)$row['playerAlive']
		);
	}
	return json_encode($row_result);
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
	case "getplayerdata": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		echo getPlayerDataAsJSON($sessionid);
		break;
	}
	default: {
		echo "invalid action";
		exit;
	}
}



?>