<?php
$serverName = gethostname();

// Get the current date and time
$currentDateTime = date('Y-m-d H:i:s');

// Welcome message
$welcomeMessage = "Welcome to PHP";

// Use shell_exec to run shell commands
$NicConfigOutput = shell_exec('ip a');

// HTML content
?>
<!DOCTYPE html>
<html>
<head>
    <title>Hello, PHP Page</title>
    <style>
        body {
            background-color: black;
            color: white;
        }
    </style>
</head>
<body>
    <h1><?php echo $welcomeMessage; ?></h1>
    <h3><?php echo $currentDateTime; ?></h3>
    <p>Container Name: <b><?php echo $serverName; ?></b></p>
    <p>Network Information:<p>
    <p><pre><?php echo $NicConfigOutput; ?><pre></p>
</body>
</html>