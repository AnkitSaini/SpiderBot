<?php
	$color =  $_POST['postcolor'];
	$xPosition = $_POST['post_x'];
	$yPosition = $_POST['post_y'];
	
	$textfile = "SpiderBot.txt"; // Declares the name and location of the .txt file
	
	$fileLocation = "$textfile";
	$fh = fopen($fileLocation, 'w   ') or die("Something went wrong!"); // Opens up the .txt file for writing and replaces any previous content
	
	$stringToWrite = "$color\n"; // Write either r,g,b,y based on color depending on request from index.html
	fwrite($fh, $stringToWrite); // Writes it to the .txt file
	
	$stringToWrite = "$xPosition\n";
	fwrite($fh, $stringToWrite); // Writes it to the .txt file
	
	$stringToWrite = "$yPosition\n";
	fwrite($fh, $stringToWrite); // Writes it to the .txt file
	
	fclose($fh);
	header("Location: SpiderBot_FrontEnd_HTML.html");
	
?>