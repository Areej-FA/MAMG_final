<?php

class DbOperation {

    private $conn;

    //Constructor
    function __construct() {
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    //Function to display list of objects in a Hall
    public function getAllObjects($id) {
        $response["objectdata"] = array();
        $int = (int) $id;

        $result = mysqli_query($this->conn, "SELECT * FROM Objects WHERE Hall_id = '" . $int . "'");
        if (!$result) {
            die('Invalid query: ' . mysqli_error($this->conn));
            echo json_encode(mysqli_error($this->conn));
        }
        while ($row = mysqli_fetch_assoc($result)) {
            $objectdata = array();

            $objectdata["Object_id"] = $row["Object_id"];
            $objectdata["Name_E"] = $row["Name_E"];
            $objectdata["Name_AR"] = $row["Name_AR"];
            if ($row["Picture"] != NULL) {
                $objectdata["Picture"] = base64_encode($row["Picture"]);
            } else {
                $objectdata["Picture"] = "NULL";
            }

            array_push($response["objectdata"], $objectdata);
        }
        $response["success"] = 1;

        echo json_encode($response);
    }

    //Function to display a single object
    public function getAnObject($id) {
        $int = (int) $id;

        $result = mysqli_query($this->conn, "SELECT * FROM Objects WHERE Object_id = '" . $int . "'");
        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["object"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp object array
            $object = array();

            $object["Object_id"] = $row["Object_id"];
            $object["Name_E"] = $row["Name_E"];
            $object["Picture"] = base64_encode($row["Picture"]);
            $object["Audio_E"] = $row["Audio_E"];
            $object["Video_E"] = $row["Video_E"];
            $object["Description_E"] = $row["Description_E"];
            $object["Resource_E"] = $row["Resource_E"];
            $object["Rate_Count"] = $row["Rate_Count"];
            $object["Rate"] = $row["Rate"];
            $object["Name_AR"] = $row["Name_AR"];
            $object["Audio_AR"] = $row["Audio_AR"];
            $object["Video_AR"] = $row["Video_AR"];
            $object["Description_AR"] = $row["Description_AR"];
            $object["Resource_AR"] = $row["Resource_AR"];

            // push single object into final response array
            array_push($response["object"], $object);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to add a single object to bookmark table
    public function setObjectInBookmark($id) {
        $int = (int) $id;

        $sql = "INSERT INTO Bookmark (Bookmark_id, Object_id, User_id) VALUES (NULL ," . $int . ", 'example2@example.com');";

        $objectdata = array();
        if ($this->conn->query($sql) === TRUE) {
            $objectdata = "successfully";
        } else {
            $objectdata = "Error";
        }
        echo json_encode($objectdata);
    }

    //Function to add a new planned tour (Plan a tour: Step 1)
    public function setPlannedTour($name, $desc, $pic) {
        $sql = "INSERT INTO Planned_tour (Tour_id, Name, Time, Description, Picture) VALUES (NULL,'" . $name . "',NULL,'" . $desc . "','" . $pic . "');";

        $objectdata = array();

        if ($this->conn->query($sql) === TRUE) {
            $objectdata["Tour_id"] = $this->conn->insert_id;
        } else {
            $objectdata["Tour_id"] = "Error";
        }

        echo json_encode($objectdata);
    }

    //Function to display a user tour history
    public function getUserFavoriteHistory($email) {
        //$Email = (string) $email;

        $result = mysqli_query($this->conn, "SELECT * FROM tour_history where User_id ='" . $email . "'");

        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();

            $product["Tour_id"] = $row["Tour_id"];
            $product["date"] = $row["date"];
            $Tour_id = $row["Tour_id"];
            $result_2 = mysqli_query($this->conn, "SELECT * FROM planned_tour where Tour_id='" . $Tour_id . "'");
            $row_2 = mysqli_fetch_array($result_2);
            // echoing JSON response
            $product["Name_E"] = $row_2['Name_E'];
            $product["Name_Ar"] = $row_2['Name_Ar'];

            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to display Wishlist
    public function getUserWishList($email) {
        //$int = (int) $id;
        $result = mysqli_query($this->conn, "SELECT * FROM Wishlist WHERE U_id ='".$email."'");
        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();

            $product["Pro_id"] = $row["Pro_id"];
            $Pro_id = $row["Pro_id"];
            $result_2 = mysqli_query($this->conn, "SELECT * FROM products where Pro_id='".$Pro_id."'");
            $row_2 = mysqli_fetch_array($result_2);
            // echoing JSON response
            $product["Name_E"] = $row_2['Name_E'];
            $product["Picture"] = base64_encode($row_2["Picture"]);
            $product["Price"] = $row_2["Price"];
            $product["Quantity"] = $row_2["Quantity"];
            $product["Description_E"] = $row_2["Description_E"];
            $product["Type"] = $row_2["Type"];
            $product["Name_Ar"] = $row_2['Name_Ar'];
            $product["Description_Ar"] = $row_2["Description_Ar"];
            $result_zero = mysqli_query($this->conn, "SELECT * FROM `wishlist` WHERE `Pro_id`='$Pro_id' AND `U_id`='$email'") or die(mysql_error());
            if (mysqli_fetch_array($result_zero) >= 1) {
                $product["product_fav"] = 1;
            } else {
                $product["product_fav"] = 0;
            }

            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to display Favorite Tour
    public function getUserFavoriteTour($email) {
        //$int = (int) $id;

        $result = mysqli_query($this->conn, "SELECT * FROM favorite_tour where User_id='" . $email . "'");

        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();

            $product["Tour_id"] = $row["Tour_id"];
            $Tour_id = $row["Tour_id"];
            $result_2 = mysqli_query($this->conn, "SELECT * FROM planned_tour where Tour_id='" . $Tour_id . "'");
            $row_2 = mysqli_fetch_array($result_2);
            // echoing JSON response
            $product["Name_E"] = $row_2['Name_E'];
            $product["Name_Ar"] = $row_2['Name_Ar'];

            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to display a specific event
    public function getEventById($id) {
        $int = (int) $id;

        $result = mysqli_query($this->conn, "SELECT * FROM event_activity where Event_id='" . $int . "'");

        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();

            $product["Activity_id"] = $row["Activity_id"];
            $product["Name_E"] = $row["Name_E"];
            $product["Name_Ar"] = $row["Name_Ar"];
            $product["Time"] = $row["Time"];
            $product["Ticket_Price"] = $row["Ticket_Price"];
            $product["Age_Group"] = $row["Age_Group"];
            $product["Event_id"] = $row["Event_id"];

            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to display all event
    public function getAllEvents() {

        $result = mysqli_query($this->conn, "SELECT * FROM event");

        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();
            $event_activity = array();

            $product["Event_id"] = $row["Event_id"];
            $Event_id = $row["Event_id"];
            $product["Name_E"] = $row["Name_E"];
            $product["Start_date"] = $row["Start_date"];
            $product["End_date"] = $row["End_date"];
            $product["Picture"] = base64_encode($row["Picture"]);
            $product["Name_AR"] = $row["Name_AR"];

            $result_2 = mysqli_query($this->conn, "SELECT * FROM event_activity where Event_id='" . $Event_id . "'");
            while ($row_2 = mysqli_fetch_assoc($result_2)) {

                // temp client array
                $activities = array();
                $activities["Activity_id"] = $row_2["Activity_id"];
                $activities["Time"] = $row_2["Time"];
                $activities["Ticket_Price"] = $row_2["Ticket_Price"];
                $activities["Age_Group"] = $row_2["Age_Group"];

                // push single product into final response array
                array_push($event_activity, $activities);
            }
            $product["activities"] = $event_activity;

            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to display all movies
    public function getAllMovies() {

        $result = mysqli_query($this->conn, "SELECT * FROM movies");

        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();
            $moive_time = array();

            $product["Moive_id"] = $row["Moive_id"];
            $Moive_id = $row["Moive_id"];
            $product["Name_E"] = $row["Name_E"];
            $product["Description_E"] = $row["Description_E"];
            $product["Picture"] = base64_encode($row["Picture"]);
            $product["Trailer"] = $row["Trailer"];
            $product["Name_AR"] = $row["Name_AR"];
            $product["Description_Ar"] = $row["Description_Ar"];

            $result_2 = mysqli_query($this->conn, "SELECT * FROM moive_time where Moive_id='" . $Moive_id . "'");
            while ($row_2 = mysqli_fetch_assoc($result_2)) {

                // temp client array
                $times = array();
                $times["Time"] = $row_2["Time"];
                $times["Day"] = $row_2["Day"];

                // push single product into final response array
                array_push($moive_time, $times);
            }
            $product["times"] = $moive_time;

            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to display all products
    public function getAllGifts($email) {

        $result = mysqli_query($this->conn, "SELECT * FROM products");

        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();

        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();

            $product["Pro_id"] = $row["Pro_id"];
            $Pro_id = $row["Pro_id"];
            $product["Name_E"] = $row['Name_E'];
            $product["Picture"] = base64_encode($row["Picture"]);
            $product["Price"] = $row["Price"];
            $product["Quantity"] = $row["Quantity"];
            $product["Description_E"] = $row["Description_E"];
            $product["Type"] = $row["Type"];
            $product["Name_Ar"] = $row['Name_Ar'];
            $product["Description_Ar"] = $row["Description_Ar"];
            $result_zero = mysqli_query($this->conn, "SELECT * FROM `wishlist` WHERE `Pro_id`='$Pro_id' AND `U_id`='$email'") or die(mysql_error());
            if (mysqli_fetch_array($result_zero) >= 1) {
                $product["product_fav"] = 1;
            } else {
                $product["product_fav"] = 0;
            }


            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    public function getAllHalls() {

        $result = mysqli_query($this->conn, "SELECT * FROM Hall");

        if (!$result) {
            die('Invalid query: ' . mysql_error());
            echo json_encode(mysql_error());
        }
        $response["product"] = array();
        
        while ($row = mysqli_fetch_assoc($result)) {
            // temp user array
            $product = array();
            $hall_objects = array();
            $product["Hall_id"] = $row["Hall_id"];
            $Hall_id = $row["Hall_id"];
            $product["Name_E"] = $row["Name_E"];
            $product["Picture"] = base64_encode($row["Picture"]);
            $product["Audio_E"] = $row["Audio_E"];
            $product["Video_E"] = $row["Video_E"];
            $product["Description_E"] = $row["Description_E"];
            $product["Name_AR"] = $row["Name_AR"];
            $product["Audio_Ar"] = $row["Audio_Ar"];
            $product["Video_AR"] = $row["Video_AR"];
            $product["Description_AR"] = $row["Description_AR"];
            $result_2 = mysqli_query($this->conn, "SELECT * FROM objects where Hall_id='" . $Hall_id . "'");
            while ($row_2 = mysqli_fetch_assoc($result_2)) {

                // temp client array
                $objects = array();
                $objects["Object_id"] = $row_2["Object_id"];
                $objects["Name_E"] = $row_2["Name_E"];
                $objects["Picture"] = base64_encode($row_2["Picture"]);
                $objects["Audio_E"] = $row_2["Audio_E"];
                $objects["Video_E"] = $row_2["Video_E"];
                $objects["Description_E"] = $row_2["Description_E"];
                $objects["Resource_E"] = $row_2["Resource_E"];
                $objects["Rate_Count"] = $row_2["Rate_Count"];
                $objects["Rate"] = $row_2["Rate"];
                $objects["Hall_id"] = $row_2["Hall_id"];
                $objects["Name_AR"] = $row_2["Name_AR"];
                $objects["Audio_AR"] = $row_2["Audio_AR"];
                $objects["Video_AR"] = $row_2["Video_AR"];
                $objects["Description_AR"] = $row_2["Description_AR"];
                $objects["Resource_AR"] = $row_2["Resource_AR"];

                // push single product into final response array
                array_push($hall_objects, $objects);
            }
            $product["objects"] = $hall_objects;

            // push single product into final response array
            array_push($response["product"], $product);
        }
        $response["success"] = 1;

        // echoing JSON response
        echo json_encode($response);
    }

    //Function to delete favourite
    public function deleteFavourite($Tour_id, $email) {

        $sql = "DELETE FROM `favorite_tour` WHERE Tour_id='$Tour_id' and User_id='$email'";

        $objectdata = array();
        if ($this->conn->query($sql) === TRUE) {
            $objectdata = "successfully";
            echo $objectdata;
        } else {
            $objectdata = "Error";
            echo "Error: " . $sql . "<br>" . $this->conn->error;
        }
        echo json_encode($objectdata);
    }

    //Function to add a single object to wishlist table
    public function setObjectInWishList($Pro_id, $email) {

        $sql = "INSERT INTO Wishlist(Pro_id, U_id) VALUES ('".$Pro_id."','".$email."')";

        $objectdata = array();
        if ($this->conn->query($sql) === TRUE) {
            $objectdata = "successfully";
            echo $objectdata;
        } else {
            $objectdata = "Error";
            echo "Error: " . $sql . "<br>" . $this->conn->error;
        }
        echo json_encode($objectdata);
    }

    //Function to save the planned tour
    public function saveUsersTour($tourID, $userID) {

        $sql1 = "INSERT INTO Touring (U_id, T_id, Tour_id) VALUES ('" . $userID . "','" . $tourID . "', NULL);";

        $objectdata = array();
        $objectdata["response"] = $tourID . " - " . $userID;

        if ($this->conn->query($sql1) === TRUE) {
            $objectdata["responseU"] = "successfully";
        } else {
            $objectdata["responseU"] = $userID;
        }

        echo json_encode($objectdata);
    }

    //Function to save the planned tour
    public function savePlannedTour($objID, $tourID) {

        $sql2 = "INSERT INTO T_object (Tour_id, Object_id, TO_id) VALUES ('" . $tourID . "','" . $objID . "',NULL);";

        $objectdata = array();

        if ($this->conn->query($sql2) === TRUE) {
            $objectdata["responseT"] = "successfully";
        } else {
            $objectdata["responseT"] = "Error";
        }

        echo json_encode($objectdata);
    }

    //Function to get all halls (Plan a tour: Step 2)
    public function returnHalls() {

        $response["objectdata"] = array();

        $result = mysqli_query($this->conn, "SELECT Hall_id, Name_E, Picture, Name_AR FROM Hall");

        if (!$result) {
            die('Invalid query: ' . mysqli_error($this->conn));
            echo json_encode(mysqli_error($this->conn));
        }
        while ($row = mysqli_fetch_assoc($result)) {
            $objectdata = array();

            $objectdata["Hall_id"] = $row["Hall_id"];
            $objectdata["Name_E"] = $row["Name_E"];
            $objectdata["Name_AR"] = $row["Name_AR"];
            $objectdata["Picture"] = base64_encode($row["Picture"]);

            array_push($response["objectdata"], $objectdata);
        }
        $response["success"] = 1;

        echo json_encode($response);
    }

    //Function to delete wishlist
    public function deleteWishlist($Pro_id, $email) {

        $sql = "DELETE FROM `wishlist` WHERE Pro_id='$Pro_id' and U_id='$email'";

        $objectdata = array();
        if ($this->conn->query($sql) === TRUE) {
            $objectdata = "successfully";
            echo $objectdata;
        } else {
            $objectdata = "Error";
            echo "Error: " . $sql . "<br>" . $this->conn->error;
        }
        echo json_encode($objectdata);
    }

}
