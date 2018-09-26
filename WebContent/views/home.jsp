<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="stylesheet" type="text/css" href="./css/style.css">
		<title>Login</title>
	</head>
	<body class="col-md-4 login">
		<h2>Social Media Network</h2>
		<div class="error" style="display:${type}"><h4>Whoops! ${error}</h4></div>
		<form action="login" method="POST">
			<input type="email" placeholder="ben@yahoo.com" name="email" required>
			<input type="password" placeholder="password" name="password" required>
			<input type="submit" class="mybtn" value="Log in"> 
		</form>
	</body>
</html>