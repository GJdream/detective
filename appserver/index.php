<?php

$con = mysqli_connect("localhost", "root", "") or die("Unable to connect to db.");
$con->select_db("appserver");
	

function newSession() {
	global $con;

	// get latest id
	$result = $con->query("SELECT max(sessionID) from sessions");
	$row = $result->fetch_array();
	$maxsession = $row[0];
	// insert new id which i
	$newsession = $maxsession+1;

	if ($con->query("INSERT INTO sessions(sessionID) VALUES(".$newsession.")")) {
		return $newsession;
	}
	else {
		echo $con->error;
	}
	return -1;
}

function addPlayerToSession($sessionID, $name) {
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

	if ($con->query("INSERT INTO sessionsInPlay(sessionID, playerID, playerName) VALUES(".$sessionID.",".$newPlayerID.",'".$name."')")) {
		changed($sessionID);
		return $newPlayerID;
	}
	else {
		return $con->error;
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

	return $result;
}


function getPlayerDataAsJSON($sessionid)
{
	global $con;

	$stmt = $con->prepare("SELECT playerID, playerName, playerRole, playerAlive FROM sessionsInPlay WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionid);
	$stmt->execute();
	$result = $stmt->get_result();

	while ($row = $result->fetch_assoc()) {
		$row_result[] = array(
			'playerID' => (int)$row['playerID'],
			'playerName' => $row['playerName'],
			'playerRole' => $row['playerRole'],
			'playerAlive' => (bool)$row['playerAlive']
		);
	}
	return json_encode($row_result);
}

function getPlayerStatuses($sessionID)
{
	global $con;
	$stmt = $con->prepare("SELECT playerAlive FROM sessionsInPlay WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	$stmt->bind_result($result);
	$output = "";

	while ($stmt->fetch()) {
		$output .= $result.",";
	}
	return $output;

}

function removePlayerFromGame($sessionID, $playerID)
{

	global $con;
	$stmt = $con->prepare("DELETE FROM sessionsInPlay WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("ii", $sessionID, $playerID);
	$stmt->execute();
	if ($stmt->affected_rows === 1) {
		changed($sessionID);
		return "OK";
	}
	else {
		return "No rows were affected, could mean that sessionID or playerID doesn't exist";
	}
}

function isGameReady($sessionID) {
	global $con;
	$stmt = $con->prepare("SELECT isReady FROM sessions WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
    }

	return $result;
}

function setGameNotReady($sessionID) {
	global $con;
	$stmt = $con->prepare("UPDATE sessions SET isReady=0 WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();

	return;
}

function startGame($sessionID) {
	global $con;
	assignRoles($sessionID);

	$stmt = $con->prepare("UPDATE sessionsinplay SET playerAlive=1 WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();


	$stmt = $con->prepare("UPDATE sessions SET isReady=1,nextSync=(?) WHERE sessionID = (?)");
	$syncTime = new DateTime();
	$syncTime = $syncTime->add(new DateInterval("PT12S")); // add 12 seconds to sync

	//echo $syncTime->format("H:i:s");
	$stmt->bind_param("si", $syncTime->format('Y-m-d H:i:s'), $sessionID);
	$stmt->execute();

	if ($stmt->affected_rows === 1) {
		return "OK";
	}
	else {
		return "startGame: No rows were affected, could mean that sessionID or playerID doesn't exist";
	}
}

function assignRoles($sessionID) {
	global $con;
	$count = getNumberOfPlayersInSession($sessionID);
	$randomKiller = rand(0, $count-1);

    // get clue at that 
    $stmt = $con->prepare("SELECT detective, killer FROM clues ORDER BY RAND()");
	$stmt->execute();
	$stmt->bind_result($detectiveClue, $killerClue);
	while ($stmt->fetch()) {
    }


	$stmt = $con->prepare("UPDATE sessionsinplay SET clue=(?) WHERE sessionID = (?)");
	$stmt->bind_param("si", $detectiveClue, $sessionID);
	$stmt->execute();
	$stmt = $con->prepare("UPDATE sessionsinplay SET playerRole=(?), clue=(?) WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("isii", $role=2, $killerClue, $sessionID, $randomKiller);
	$stmt->execute();
}



function changed($sessionID) {
	global $con;

    $stmt = $con->prepare("UPDATE sessionsinplay SET changed=1 WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();

	if ($stmt->affected_rows > 0) {
		return "OK";
	}
	else {
		return "changed: No rows were affected, could mean that sessionID or playerID doesn't exist";
	}

}

function changeCleared($sessionID, $playerID) {
	global $con;

    $stmt = $con->prepare("UPDATE sessionsinplay SET changed=0 WHERE sessionID = (?) AND playerID = (?)");

	$stmt->bind_param("ii", $sessionID, $playerID);
	$stmt->execute();

	if ($stmt->affected_rows == 1) {
		return "OK";
	}
	else {
		return "changeCleared: No rows were affected, could mean that sessionID or playerID doesn't exist";
	}
}

function isChanged($sessionID, $playerID) {
	global $con;

	$stmt = $con->prepare("SELECT changed FROM sessionsinplay WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("ii", $sessionID, $playerID);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
    }
	return $result;	
}

function getRoleAndClue($sessionID, $playerID)
{
	// TODO synctime
	global $con;

	$stmt = $con->prepare("SELECT playerRole, clue FROM sessionsinplay WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("is", $sessionID, $playerID);
	$stmt->execute();
	$stmt->bind_result($role, $clue);
	while ($stmt->fetch()) {
    }

    $stmt = $con->prepare("SELECT nextSync FROM sessions WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
		$stmt->execute();
	$stmt->bind_result($nextSync);
	while ($stmt->fetch()) {
    }
    
    $nextSync = new DateTime($nextSync);
    $now = new DateTime();
    $diff = $now->diff($nextSync);

	return ((string)$role).";".$clue.";".$diff->s;
}

function createRandomPlayOrder($sessionID)
{
	$numberOfPlayers = getNumberOfPlayersInSession($sessionID);

	$randomArray = array();
	for ($i = 0; $i<$numberOfPlayers; $i++)
	{
		$randomArray[] = $i;
	}
	shuffle($randomArray);
	$commaSeparated = implode($randomArray, ",");

	global $con;
	$stmt = $con->prepare("UPDATE sessions SET playOrder=(?) WHERE sessionID = (?)");
	$stmt->bind_param("si", $commaSeparated, $sessionID);
	$stmt->execute();

	return $commaSeparated;
}

function getPlayOrder($sessionID, $playerID)
{
	global $con;
	$stmt = $con->prepare("SELECT playOrder FROM sessions WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
    }

    if ($result == null) {
    	$result = createRandomPlayOrder($sessionID);
    }

    $stmt = $con->prepare("UPDATE sessionsinplay SET orderGot=1 WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("ii", $sessionID, $playerID);
	$stmt->execute();

	return $result;	
}

function isOrderCleared($sessionID)
{
	global $con;
	$stmt = $con->prepare("SELECT orderGot FROM sessionsinPlay WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
		if ($result == 0)
		{
			return false;
		}
    }
    return true;
}

function clearOrder($sessionID)
{
	global $con;
    $stmt = $con->prepare("UPDATE sessionsinplay SET orderGot=0 WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();

	$stmt = $con->prepare("UPDATE sessions SET playOrder=(?) WHERE sessionID = (?)");
	$stmt->bind_param("si", createRandomPlayOrder($sessionID), $sessionID);
	$stmt->execute();

	if ($stmt->affected_rows > 0) {
		return "clearOrder: OK";
	}
	else {
		return "clearOrder: No rows were affected";
	}
}

////////////////////// voting

function clearVotes($sessionID)
{
	global $con;
	$stmt = $con->prepare("UPDATE sessionsinplay SET voteThisRound=-1,voteSum=0,votesForElimination=0 WHERE sessionID = (?)");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();

	if ($stmt->affected_rows > 0) {
		return "clearVotes: OK";
	}
	else {
		return "clearVotes: No rows were affected";
	}
}

// playerID is the voting player, voteID is the affected player
function addVoteFromDetective($sessionID, $playerID, $voteID)
{
	if ($voteID < 0 or $voteID >= getNumberOfPlayersInSession($sessionID))
	{
		return "addVoteFromDetective: Invalid voteID: ".$voteID;
	}
	echo "{$playerID} votes for {$voteID}";
	global $con;
	$stmt = $con->prepare("UPDATE sessionsinplay SET voteThisRound=(?) WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("iii", $voteID, $sessionID, $playerID);
	$stmt->execute();

	$stmt = $con->prepare("UPDATE sessionsinplay SET voteSum=voteSum+1 WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("ii", $sessionID, $voteID);
	$stmt->execute();

	if ($stmt->affected_rows > 0) {
		if(hasEveryoneVoted($sessionID))
		{
			tallyVotes($sessionID);
		}
		return "addVoteFromDetective: OK";
	}
	else {
		return "addVoteFromDetective: No rows were affected";
	}
}

function addVoteFromKiller($sessionID, $playerID, $voteID)
{
	if ($voteID < 0 or $voteID >= getNumberOfPlayersInSession($sessionID))
	{
		return "addVoteFromKiller: Invalid voteID: ".$voteID;
	}

	echo "{$playerID} tries to eliminate {$voteID}";
	global $con;
	$stmt = $con->prepare("UPDATE sessionsinplay SET voteThisRound=(?) WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("iii", $voteID, $sessionID, $playerID);
	$stmt->execute();

	$stmt = $con->prepare("UPDATE sessionsinplay SET votesForElimination=votesForElimination+1 WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("ii", $sessionID, $voteID);
	$stmt->execute();

	if ($stmt->affected_rows > 0) {
		if(hasEveryoneVoted($sessionID))
		{
			tallyVotes($sessionID);
		}
		return "addVoteFromKiller: OK";

	}
	else {
		return "addVoteFromKiller: No rows were affected";
	}
}

function addVoteFromPolice($sessionID, $playerID, $playerToNullify)
{
	if ($playerToNullify < 0 or $playerToNullify >= getNumberOfPlayersInSession($sessionID))
	{
		return "addVoteFromPolice: Invalid voteID: ".$playerToNullify;
	}

	global $con;
	// register own vote
	$stmt = $con->prepare("UPDATE sessionsinplay SET voteThisRound=(?) WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("iii", $playerToNullify, $sessionID, $playerID);
	$stmt->execute();

	// find role of player whom they wish to nullify
	$stmt = $con->prepare("SELECT playerRole FROM sessionsinplay WHERE sessionID = (?) AND playerID = (?)");
	$stmt->bind_param("ii", $sessionID, $playerToNullify);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
    }

    switch ($result) {
    	case 0: { // the voted player was a detective, find the player that the detective voted on and decrease their vote sum
			$stmt = $con->prepare("SELECT voteThisRound FROM sessionsinplay WHERE sessionID = (?) AND playerID = (?)");
			$stmt->bind_param("ii", $sessionID, $playerToNullify);
			$stmt->execute();
			$stmt->bind_result($votedPlayer);
			while ($stmt->fetch()) {
		    }

			$stmt = $con->prepare("UPDATE sessionsinplay SET voteSum=voteSum-1 WHERE sessionID = (?) AND playerID = (?)");
			$stmt->bind_param("ii", $sessionID, $votedPlayer);
			$stmt->execute();
    		return "addVoteFromPolice: voted for nullify of detective with playerID {$playerToNullify} Nullified action of player with ID {$votedPlayer}";
    	}
    	case 1: { 
    		return "addVoteFromPolice: voted for nullify of another police with playerID {$playerToNullify} - no action taken";
    	}
    	case 2: { // the voted player was a killer, find the player that the killer voted on and decrease their vote for elimination sum
			$stmt = $con->prepare("SELECT voteThisRound FROM sessionsinplay WHERE sessionID = (?) AND playerID = (?)");
			$stmt->bind_param("i", $sessionID);
			$stmt->execute();
			$stmt->bind_result($votedPlayer);
			while ($stmt->fetch()) {
		    }

			$stmt = $con->prepare("UPDATE sessionsinplay SET votesForElimination=votesForElimination-1 WHERE sessionID = (?) AND playerID = (?)");
			$stmt->bind_param("ii", $sessionID, $votedPlayer);
			$stmt->execute();
    		return "addVoteFromPolice: voted for nullify of killer with playerID {$playerToNullify} who attempted to play player with ID {$votedPlayer}";
    	}
    }
}

function hasEveryoneVoted($sessionID)
{
	global $con;
	$stmt = $con->prepare("SELECT voteThisRound FROM sessionsinplay WHERE sessionID = (?) AND playerAlive = 1");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	$stmt->bind_result($result);
	while ($stmt->fetch()) {
		if ($result == -1) {
			return false;
		}
    }
    
    return true;
}

function tallyVotes($sessionID)
{


	echo "Tallying votes...<br/>";
	global $con;

	$stmt = $con->prepare("SELECT voteSum, playerID FROM sessionsinplay WHERE sessionID = (?) ORDER BY voteSum DESC LIMIT 0,2");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	$stmt->bind_result($voteSum, $playerID);
	
	$playerIDToEliminateByVotes = -1;
	$temphigh = 0;
	$tie = false;
	while ($stmt->fetch()) {
		if ($voteSum == $temphigh && $voteSum != 0) {
			$tie = true;
		}
		if ($voteSum > $temphigh) {
			$temphigh = $voteSum;
			$tie = false;
			$playerIDToEliminateByVotes = $playerID;
		}
	}

	if ($playerIDToEliminateByVotes >= 0 && !$tie) {
		echo "Eliminating playerID {$playerIDToEliminateByVotes} by votes<br/>";
		$stmt = $con->prepare("UPDATE sessionsinplay SET playerAlive=0 WHERE sessionID = (?) AND playerID = (?)");
		$stmt->bind_param("ii", $sessionID, $playerIDToEliminateByVotes);
		$stmt->execute();
	}
	else {
		echo "No player eliminated by votes<br/>";
	}

	$stmt = $con->prepare("UPDATE sessionsinplay SET playerAlive=0 WHERE sessionID = (?) AND votesForElimination = 1");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	

	if ($stmt->affected_rows > 0) {
		echo "Eliminating someone<br/>";
	}
	else {
		echo "No player eliminated by kill<br/>";
	}

    clearVotes($sessionID); 

    //return getPlayerStatuses($sessionID);
}

function skipVote($sessionID, $playerID) {
	global $con;
	$stmt = $con->prepare("UPDATE sessionsinplay SET voteThisRound=100 WHERE sessionID = (?) AND playerID=(?)");
	$stmt->bind_param("ii", $sessionID, $playerID);
	$stmt->execute();

	if ($stmt->affected_rows > 0) {
		if(hasEveryoneVoted($sessionID))
		{
			tallyVotes($sessionID);
		}
		return "skipVote: OK";
	}
	else {
		return "skipVote: No rows were affected";
	}
}


// 0 for no win, 1 for detective win, 2 for killer win
function gameHasWinningCondition($sessionID) {

	/*
	if(number of killer == 0){
		Detectives Win;
	}
	else{
		if(number of all alive player > 2){ //at least 3, so you could also use >=3
			game not finished;
		}
		else{
			Killers Win;
		}	
	} */
	

	global $con;
	$stmt = $con->prepare("SELECT count(*) FROM sessionsInPlay WHERE sessionID = (?) AND playerAlive = 1 AND playerRole = 2");
	$stmt->bind_param("i", $sessionID);
	$stmt->execute();
	$stmt->bind_result($result); // number of alive killers
	while ($stmt->fetch()) {
    }

    if ($result == 0) {
    	setGameNotReady($sessionID);
    	return 1;
    }
    else {
    	$stmt = $con->prepare("SELECT count(*) FROM sessionsInPlay WHERE sessionID = (?) AND playerAlive = 1");
		$stmt->bind_param("i", $sessionID);
		$stmt->execute();
		$stmt->bind_result($result); // number of alive players
		while ($stmt->fetch()) {
    	}

    	if ($result >= 3) {
    		return 0;
    	}
    	else {
    		setGameNotReady($sessionID);
    		return 2;
    	}
    }
}



/////////// http GET routing
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
		if (!isset($_GET["name"]))
		{
			echo "name is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		$name = $_GET["name"];
		echo addPlayerToSession($sessionid, $name);
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
	case "getplayerstatuses": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		echo getPlayerStatuses($sessionid);
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
	case "removeplayer": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		echo removePlayerFromGame($sessionid, $playerid);
		break;
	}
	case "sessionready": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		echo isGameReady($sessionid);
		break;
	}
	case "startgame": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		echo startGame($sessionid);
		break;
	}
	case "ischanged": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		echo isChanged($sessionid, $playerid);
		break;
	}
	case "changecleared": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		echo changeCleared($sessionid, $playerid);
		break;
	}
	case "getsecret": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		echo getRoleAndClue($sessionid, $playerid);
		break;
	}
	case "createrandomplayorder": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		echo createRandomPlayOrder($sessionid);
		break;
	}
	case "getplayorder": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		echo getPlayOrder($sessionid, $playerid);
		break;
	}
	case "isordercleared": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		echo isOrderCleared($sessionid);
		break;
	}
	case "clearorder": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		echo clearOrder($sessionid);
		break;
	}
	case "clearvotes": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		echo clearVotes($sessionid);
		break;
	}
	case "addvotefromdetective": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}
		if (!isset($_GET["voteid"]))
		{
			echo "voteid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		$voteid = (int)$_GET["voteid"];
		echo addVoteFromDetective($sessionid, $playerid, $voteid);
		break;
	}
	case "addvotefromkiller": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}
		if (!isset($_GET["voteid"]))
		{
			echo "voteid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		$voteid = (int)$_GET["voteid"];
		echo addVoteFromKiller($sessionid, $playerid, $voteid);
		break;
	}
	case "skipvote": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		echo skipVote($sessionid, $playerid);
		break;
	}
	case "addvotefrompolice": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}
		if (!isset($_GET["playerid"]))
		{
			echo "playerid is not set";
			exit;
		}
		if (!isset($_GET["voteid"]))
		{
			echo "voteid is not set";
			exit;
		}
		$sessionid = (int)$_GET["sessionid"];
		$playerid = (int)$_GET["playerid"];
		$voteid = (int)$_GET["voteid"];
		echo addVoteFromPolice($sessionid, $playerid, $voteid);
		break;
	}
	case "detectwinningcondition": {
		if (!isset($_GET["sessionid"]))
		{
			echo "sessionid is not set";
			exit;
		}

		$sessionid = (int)$_GET["sessionid"];
		echo gameHasWinningCondition($sessionid);
		break;
	}
	default: {
		echo "invalid action";
		exit;
	}
}



?>