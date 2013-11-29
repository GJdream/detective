<?php

function addUser($username) {
	echo "hello ".$username;

	$con = mysqli_connect("localhost", "root", "root");
}

function newSession() {
	$con = mysqli_connect("localhost", "root", "root");
	if ($con) {
		mysqli_select_db($con, "appserver");
		if ($result = $con->query("INSERT INTO sessions(userID) VALUES (0);")) {
			echo ($con->insert_id);
		}
	}

	$con->close();
}

function addPlayerToSession($sessionid) {
	$con = mysqli_connect("localhost", "root", "root");
	$newUserID = -1;


	if ($con) {
		mysqli_select_db($con, "appserver");

		$query = "SELECT * FROM sessions WHERE sessionID = ".$sessionid;
		if ($stmt = $con->prepare($query)) {

    		/* execute query */
    		$stmt->execute();

    		/* store result */
   			 $stmt->store_result();

    		 //printf("Number of rows: %d.\n", $stmt->num_rows);
    		 $newUserID = $stmt->num_rows;
    		 echo $newUserID;
		}
		$query = "INSERT INTO sessions VALUES (".$sessionid.",".$newUserID.")";
		if ($stmt = $con->prepare($query)) {
    		/* execute query */
    		$stmt->execute();

    		/* store result */
   			 $stmt->store_result();

   			 echo $stmt->error_no();
		}
		    		/* close statement */
   		 $stmt->close();
	}
}


addPlayerToSession(14);



?>