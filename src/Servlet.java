

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import social.dao.FriendsDAO;
import social.dao.PostDAO;
import social.dao.RequestDAO;
import social.dao.UserDAO;
import social.model.Friends;
import social.model.Post;
import social.model.Request;
import social.model.User;

/**
 * Servlet implementation class Servlet
 */
@WebServlet(urlPatterns={"/","/login"})
public class Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String path = null;
	private User user = null;
	private Post post = null;
	private Friends friend = null;
	private UserDAO u_bo = new UserDAO();
	private PostDAO p_bo = new PostDAO();
	private FriendsDAO f_bo = new FriendsDAO();
	private RequestDAO r_bo = new RequestDAO();
	private HttpSession session = null;
    private String email = null;
    private String pass = null;
    private List<Post> myPosts = null;
    private List<Post> myFriendsPost = null;
    private List<Friends> myFriends = null;
    private List<Friends> allFriends = null;
    private List<Request> myRequest = null;
    private List<Post> aux=null;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//Getting my path
		path = request.getServletPath();
		switch(path) {
			//User views dispatcher
			case "/login": 
				getLogin(request, response);
				break;
			case "/wall": 
				hideError(request, response);
				getMain(request, response, "wall");
				break;
			case "/friends": 
				getMain(request, response, "friend");
				break;
			case "/notifications": 
				getMain(request, response, "notification");
				break;
			case "/logout": 
				hideError(request, response); 
				request.getRequestDispatcher("/views/home.jsp").forward(request, response);
				session.invalidate();
				break;
			default: 
				hideError(request, response);
				request.getRequestDispatcher("/views/home.jsp").forward(request, response);
				break;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		path = request.getServletPath();
		switch(path) {
			//User views dispatcher
			case "/login": logIn(request, response);break;
			case "/addPost": addPost(request, response);break;
			case "/deletePost": deletePost(request, response);break;
			case "/editPost": editPost(request, response);break;
			case "/sendRequest": sendRequest(request, response);break;
			case "/updateRequest": updateRequest(request, response);break;
		}
	}
	/* POST METHODS */
	public void logIn(HttpServletRequest _req, HttpServletResponse _res) throws ServletException, IOException {
		//Getting parameters and setting my global object for my class
		email = _req.getParameter("email");
		pass = _req.getParameter("password");
		if (email.isEmpty() || pass.isEmpty()) {
			displayError(_req, _res);
			_req.setAttribute("error", "The email and password can't be empty");
			_req.getRequestDispatcher("/views/home.jsp").forward(_req, _res);
		} else {
			if ( !(isEmail(email))){
				displayError(_req, _res);
				_req.setAttribute("error", "Email format is incorrect");
				_req.getRequestDispatcher("/views/home.jsp").forward(_req, _res);
			}else {
				try {
					if (u_bo.getUserByEmail(email)!=null) {
						user = u_bo.getUserByEmail(email);
						if (user.getPass().equals(pass)) {
							//If the user information is correct, then verify if a session exists
							//if it does, delete that session and start a new one.
							session = _req.getSession(false);
							if (session != null) {
								session.invalidate();
							}
							session = _req.getSession();
							//After 15 min of inactivity the session will expire
							session.setMaxInactiveInterval(15*60);
							session.setAttribute("current", user);
							hideError(_req, _res);
							getMain(_req,_res,"wall");
						}else {
							System.out.println("Display error Wrong credentials");
							displayError(_req, _res);
							_req.setAttribute("error", "Password is incorrect");
							_req.getRequestDispatcher("/views/home.jsp").forward(_req, _res);
						}
					}else {
						System.out.println("Display error user doesn't exists");
						displayError(_req, _res);
						_req.setAttribute("error", "No account with that email");
						_req.getRequestDispatcher("/views/home.jsp").forward(_req, _res);
					}	
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
	
	public void addPost(HttpServletRequest _req, HttpServletResponse _res) throws ServletException, IOException {
			String new_post = _req.getParameter("new-post");
			Integer post_id = null;
			if (new_post.isEmpty()) {
				_req.setAttribute("error", "Empty post? What are you doing?");
				displayError(_req, _res);
				getMain(_req,_res,"wall");
			}else {
				post = new Post();
				post.setPost_text(new_post);
				post.setUser_id(user.getUser_id());
				post.setDate_col(new java.sql.Date(System.currentTimeMillis()));
				post_id = p_bo.postOnWall(post);
				if ( post_id != null) {
					hideError(_req, _res);
					getMain(_req,_res,"wall");
				}else {
					_req.setAttribute("error", "Something happend, try later");
					displayError(_req, _res);
					getMain(_req,_res,"wall");
				}
			}
	}
	
	public void editPost(HttpServletRequest _req, HttpServletResponse _res) throws ServletException, IOException {
		Post p = new Post();
		p.setPost_id(Integer.parseInt(_req.getParameter("postIdToEdit")));
		p.setPost_text(_req.getParameter("editedPost"));
		p_bo.editPostOnWall(p);
		hideError(_req, _res);
		getMain(_req,_res,"wall");
	}
	
	public void deletePost(HttpServletRequest _req, HttpServletResponse _res) throws ServletException, IOException {
		p_bo.deletePostOnWall(Integer.parseInt(_req.getParameter("postIdToDelete")));
		hideError(_req, _res);
		getMain(_req,_res,"wall");
	}
	
	public void sendRequest(HttpServletRequest _req, HttpServletResponse _res) throws ServletException, IOException {
		Integer fR = Integer.parseInt(_req.getParameter("friend-request"));
		r_bo.requestFriendShip(user.getUser_id(), fR);
		_req.setAttribute("friendRequested", fR);
		getMain(_req,_res,"friend");
	}
	
	public void updateRequest(HttpServletRequest _req, HttpServletResponse _res) throws ServletException, IOException {
		Integer reqId = Integer.parseInt(_req.getParameter("requestId"));
		Integer userId = Integer.parseInt(_req.getParameter("userId"));
		/*REJECT REQ*/
		if (_req.getParameter("action").equals("Decline")){
			r_bo.requestUpdate(reqId, -1);
		}else {
			r_bo.requestUpdate(reqId, 1);
			friend = new Friends();
			friend.setUser_request(userId);
			friend.setUser_accepted(user);
			friend.setRequest_id(reqId);
			f_bo.confirmFriendShip(friend);
		}
		getMain(_req,_res,"notification");
	}
	
	/* GET VIEWS*/
	public void getLogin(HttpServletRequest _req, HttpServletResponse _res) throws ServletException, IOException {
		hideError(_req, _res);
		_req.getRequestDispatcher("/views/home.jsp").forward(_req, _res);
	}
	
	public void getMain(HttpServletRequest _req, HttpServletResponse _res, String section) throws ServletException, IOException {
		session = _req.getSession(false);
		if( session != null && session.getAttribute("current")!=null) { 
			switch (section){
				case "wall": 
					getMyPosts(_req, _res);
					getMyFriends(_req, _res);
					activateWall(_req, _res);
					break;
				case "friend":
					if (_req.getParameter("friends-select") != null){
						if (_req.getParameter("friends-select").equals("my-friends")) {
							_req.setAttribute("all_friends", "none");
							_req.setAttribute("my_friends", "flex");
							getMyFriends(_req, _res);
						}else {
							_req.setAttribute("all_friends", "flex");
							_req.setAttribute("my_friends", "none");
							getAllFriends(_req, _res);
						}
					}else {
						_req.setAttribute("all_friends", "flex");
						_req.setAttribute("my_friends", "none");
						getAllFriends(_req, _res);
					}
					getAllRequested(_req,_res);
					activateFriends(_req, _res);
					break;
				case "notification": 
					getNotifications(_req,_res);
					activateNotifications(_req, _res);break;
			} 
			_req.getRequestDispatcher("/views/main.jsp").forward(_req, _res);
		}else {
			displayError(_req, _res);
			_req.setAttribute("error", "You have to log in first");
			_req.getRequestDispatcher("/views/home.jsp").forward(_req, _res);
		}
	}
	
	
	/* FUNCTIONS */
	public boolean isEmail(String s) {
        return s.matches("^[-0-9a-zA-Z.+_]+@[-0-9a-zA-Z.+_]+\\.[a-zA-Z]{2,4}");
    }
	
	public void displayError(HttpServletRequest _req, HttpServletResponse _res){
		_req.setAttribute("type", "block");
	}
	
	public void hideError(HttpServletRequest _req, HttpServletResponse _res){
		_req.setAttribute("type", "none");
	}
	
	public void activateWall(HttpServletRequest _req, HttpServletResponse _res) {
		_req.setAttribute("wall", "flex"); 
		_req.setAttribute("friend", "none"); 
		_req.setAttribute("notification", "none");
	}
	
	public void activateFriends(HttpServletRequest _req, HttpServletResponse _res) {
		_req.setAttribute("wall", "none"); 
		_req.setAttribute("friends", "block"); 
		_req.setAttribute("notification", "none");
	}
	
	public void activateNotifications(HttpServletRequest _req, HttpServletResponse _res) {
		_req.setAttribute("wall", "none"); 
		_req.setAttribute("friend", "none"); 
		_req.setAttribute("notification", "flex");
	}
	
	/* DATA TO DISPLAY*/
	public void getMyPosts(HttpServletRequest _req, HttpServletResponse _res) {
		/* WARNING: NOT A VERY GOOD WAY TO HANDLE THE LIST OF POSTS THAT IS
		 * BRINGING USER POST AND FRIENDS POST TOGETHER, BUT I WAS TOLD 
		 * 	THAT I SHOULD TRY NOT TO CHANGE MUCH IN THE CODE
		 * */
		aux = new ArrayList<Post>();
		myPosts = new ArrayList<Post>();
		myFriendsPost = new ArrayList<Post>();
		aux = p_bo.getPostRelatedToUser(user.getUser_id());
		for(Post post:aux) {
			if ( post.getUser().getUser_id()==user.getUser_id()) {
				myPosts.add(post);
			}else {
				myFriendsPost.add(post);
			}
		}
		_req.setAttribute("myPosts", myPosts); 
		_req.setAttribute("myFriendsPost", myFriendsPost);
	}
	
	public void getMyFriends(HttpServletRequest _req, HttpServletResponse _res) {
		myFriends = f_bo.getAllUserFriends(user.getUser_id());
		if ( !(myFriends.isEmpty()) || myFriends != null ) {
			_req.setAttribute("myFriends", myFriends); 
		}
	}
	
	public void getAllFriends(HttpServletRequest _req, HttpServletResponse _res) {
		allFriends = f_bo.getAllNonFriends(user.getUser_id());
		if ( !(allFriends.isEmpty()) || allFriends != null ) {
			_req.setAttribute("allFriends", allFriends); 
		}
	}
	
	public void getAllRequested(HttpServletRequest _req, HttpServletResponse _res) {
		List<Integer> allRequested = r_bo.getAllRequested(user.getUser_id());
		if (!(allRequested.isEmpty())) {
			_req.setAttribute("allRequested", allRequested); 
		}
	}
	
	public void getNotifications(HttpServletRequest _req, HttpServletResponse _res) {
		myRequest = r_bo.getRequest_To(user.getUser_id());
		if (!(myRequest.isEmpty())) {
			_req.setAttribute("myNotifications", myRequest); 
		}

	}
}
