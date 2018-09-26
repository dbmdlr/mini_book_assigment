<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
		<link rel="stylesheet" type="text/css" href="./css/style.css">
		<title>Social Media Network</title>
	</head>
	<body>
		<div class="nav-bar">
			<ul>
				<li style="float:left;"><a id="brand" href="#">Mini Book</a></li>
				<li><a href="logout">Log out</a></li>
				<li><a href="notifications">Notifications</a></li>
				<li><a href="friends">Friends</a></li>
				<li><a href="wall">Wall</a></li>
			</ul>
		</div>
		<div class="Wall" style="display:${wall}">
			<div class="profile column">
				<h5>My profile</h5>
				<hr>
				<div class="my-profile">
					<div class="card post">
						<img class="card-img-top" src="./images/${current.getImg()}" alt="Card image cap">
						<h5 class="card-title">${current.getFirst_name()} ${current.getLast_name()} </h5>
    					<h6 class="card-subtitle mb-2 text-muted">${current.getEmail()}</h6>
					 	<div class="card-body">
					    	<p class="card-text">
					    		<b>About me</b><br>
					    		${current.getAboutMe()}
					    	</p>
					  	</div>
					</div>
				</div>
				<br>
				<h5>My posts</h5>
				<hr>
				<div class="my-posts">
					<c:choose>
					    <c:when test="${not empty myPosts}">
					    	<c:forEach var = "i" items="${myPosts}">
								<div class="card text-right post" style="width: 20rem;">					
								  <div class="card-body">
								  	<form method="POST" action="deletePost">
									  	<input type="hidden" name="postIdToDelete" value="${i.getPost_id()}">
									    <h6 class="card-subtitle mb-2 text-muted"><c:out value = "${i.getDate_col()}"/></h6>
									    <p class="card-text" style="padding-bottom:10px;">
											<c:out value = "${i.getPost_text()}"/>
										</p>
									    <button type="submit" class="btn btn-danger">Delete</button>
									    <a class="btn mybtn" style="color:white" data-toggle="modal" data-target="#hi_${i.getPost_id()}">Edit</a>
									</form>
								  </div>
								</div>
								<br>
								<!-- MODAL -->
								<div class="modal fade" id="hi_${i.getPost_id()}" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
								  <div class="modal-dialog" role="document">
								    <div class="modal-content">
								      <div class="modal-header">
								        <h5 class="modal-title" id="exampleModalLabel">Edit my post!</h5>
								        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
								          <span aria-hidden="true">&times;</span>
								        </button>
								      </div>
								      <form method="POST" action="editPost">
									      <div class="modal-body">
									      		<input type="hidden" name="postIdToEdit" value="${i.getPost_id()}">
									      		<textarea class="form-control" name="editedPost" id="exampleFormControlTextarea1" rows="5">${i.getPost_text()}</textarea>
									      </div>
									      <div class="modal-footer">
									        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
									        <button type="submit" class="btn mybtn">Save changes</button>
									      </div>
								      </form>
								    </div>
								  </div>
								</div>
								<!-- /MODAL -->
							</c:forEach>
					    </c:when>
					    <c:otherwise>
					    	<div class="alert alert-info" role="alert">
							  What are you waiting for?— Start posting!
							</div>
					    </c:otherwise>
					</c:choose>
				</div>
			</div>
			<div class="init column">
				<h5>My index</h5>
				<hr>
				<div class="new-post">
					<form class="input-group mb-3" method="POST" action="addPost">
					  <textarea name="new-post" class="form-control" aria-label="With textarea" placeholder="New post" required></textarea>
					  <div class="input-group-append">
					    <input class="btn btn-outline-secondary" value="Post" type="submit" id="button-addon2">
					  </div>
					</form>
					<div class="error-main" style="display:${type}"><p>Whoops! ${error}</p></div>
				</div>
				<br>
				<h5>My friend posts</h5>
				<hr>
				<div class="friend-posts">
					<c:choose>
					    <c:when test="${not empty myFriendsPost}">
					    	<c:forEach var = "i" items="${myFriendsPost}">
								<div class="card text-right friend-card post" style="width: 20rem;">
									<img class="card-img-top friend-img" src="./images/${i.user.getImg()}" alt="Card image cap">
									<h5 class="card-title"><c:out value = "${i.user.getFirst_name()} ${i.user.getLast_name()}"/></h5>
									<div class="card-body">
									  	<h6 class="card-subtitle mb-2 text-muted"><c:out value = "${i.getDate_col()}"/></h6>
									  	<p class="card-text" style="padding-bottom:10px;">
											<c:out value = "${i.getPost_text()}"/>
										</p>
									</div>
								</div>
								<br>
							</c:forEach>
					    </c:when>
					    <c:otherwise>
					    	<div class="alert alert-info" role="alert">
							  Your friends don't have much to say— Post something!
							</div>
					    </c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<div class="friends" style="display:${friend}">
			<div class="column">
				<h5>Friends</h5>
				<hr>
				<form method="GET" action="friends">
					<div class="input-group mb-3" style="padding:15px">
					  <div class="input-group-prepend">
					    <label class="input-group-text" for="inputGroupSelect01">Look for...</label>
					  </div>
					  <select name="friends-select" class="custom-select" id="inputGroupSelect01">
					  	<option selected disabled>Choose..</option>
					    <option value="my-friends">My friends</option>
					    <option value="all-friends">All friends</option>
					  </select>
					  <div class="input-group-append">
					    <input class="btn btn-outline-secondary" type="submit" value="Search">
					  </div>
					</div>
				</form>
				<br>
				<div class="my-friends-section" style="display:${my_friends}">
					<c:choose>
					    <c:when test="${not empty myFriends}">
					    	<c:forEach var = "i" items="${myFriends}">
					    		<div class="col-md-4">
									<div class="card text-left friend-card post">
										<img class="card-img-top friend-img" src="./images/${i.getUser_accepted().getImg()}" alt="Card image cap">
										<h5 class="card-title">${i.getUser_accepted().getFirst_name()} ${i.getUser_accepted().getLast_name()}</h5>
										<div class="card-body">
										  	<h6 class="card-subtitle mb-2 text-muted"></h6>
										  	<p class="card-text" style="padding-bottom:10px;">
										  		<b>About me</b><br>
										  		<c:out value = "${i.getUser_accepted().getAboutMe()}"/>
											</p>
										</div>
									</div>
								</div>	
								<br>
							</c:forEach>
					    </c:when>
					    <c:otherwise>
					    	<div class="alert alert-info" role="alert">
							  No friends yet?— Start looking for them!
							</div>
					    </c:otherwise>
					</c:choose>
				</div>
				<div class="all-friends-section" style="display:${all_friends}">
					<c:choose>
					    <c:when test="${not empty allFriends}">
					    	<c:forEach var = "k" items="${allFriends}">
					    		<div class="col-md-4">
									<div class="card text-left friend-card post">
										<img class="card-img-top friend-img" src="./images/${k.getUser_accepted().getImg()}" alt="Card image cap">
										<h5 class="card-title">${k.getUser_accepted().getFirst_name()} ${k.getUser_accepted().getLast_name()}</h5>
										<div class="card-body">
										  	<h6 class="card-subtitle mb-2 text-muted"></h6>
										  	<p class="card-text" style="padding-bottom:10px;">
										  		<b>About me</b><br>
										  		<c:out value = "${k.getUser_accepted().getAboutMe()}"/>
											</p>
											<c:choose>
												<c:when test="${not empty allRequested}">
													<c:set var="exist" value="false" scope = "page"/>
													<c:forEach var="item" items="${allRequested}">
														<c:if test="${exist eq false}">
															<c:if test="${item eq k.getUser_accepted().getUser_id()}">
																		<span style="padding:10px; color:white" class="badge badge-success">Friend requested</span>
																		<c:set var="exist" value="true"/>
															</c:if>
														</c:if>
													</c:forEach>
													<c:if test="${exist eq false}">
														<form action="sendRequest" method="POST">
															<input type="hidden" name="friend-request" value="${k.getUser_accepted().getUser_id()}">
															<input type="submit" class="btn mybtn" value="Friend request">
														</form>
													</c:if>
												</c:when>
												<c:otherwise>
													<form action="sendRequest" method="POST">
														<input type="hidden" name="friend-request" value="${k.getUser_accepted().getUser_id()}">
														<input type="submit" class="btn mybtn" value="Friend request">
													</form>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
								</div>
								<br>
							</c:forEach>
					    </c:when>
					    <c:otherwise>
					    	<div class="alert alert-info" role="alert">
							  No friends available— Try later!
							</div>
					    </c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<div class="notifications" style="display:${notification}">
			<div class="column">
				<h5>Notifications</h5>
				<hr>
				<div class="notification-section" style="display:flex">
					<c:choose>
						<c:when test="${not empty myNotifications}">
							<c:forEach var = "x" items="${myNotifications}">
					    		<div class="col-md-4">
									<div class="card text-left friend-card post">
										<img class="card-img-top friend-img" src="./images/${x.getUser_request().getImg()}" alt="Card image cap">
										<h5 class="card-title">${x.getUser_request().getFirst_name()} ${x.getUser_request().getLast_name()}</h5>
										<div class="card-body">
										  	<h6 class="card-subtitle mb-2 text-muted"></h6>
										  	<p class="card-text" style="padding-bottom:10px;">
										  		<b>About me</b><br>
										  		<c:out value = "${x.getUser_request().getAboutMe()}"/>
											</p>
											<form action="updateRequest" method="POST">
												<input type="hidden" name="userId" value="${x.getUser_request().getUser_id()}">
												<input type="hidden" name="requestId" value="${x.getRequest_id()}">
												<input type="submit" name="action" class="btn btn-danger" value="Decline">
		    									<input type="submit" name="action" class="btn mybtn" value="Accept">
	    									</form>
										</div>
									</div>
								</div>	
								<br>
							</c:forEach>
						</c:when>
					    <c:otherwise>
					    	<div class="alert alert-info" role="alert">
							  There's no notifications yet — Try later!
							</div>
					    </c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
	</body>
</html>