import React from 'react';
import { Link, Route } from 'react-router-dom';
import LoginFormContainer from '../session/login_form_container';
import SearchBarContainer from '../search/search_bar_container';
import { AuthRoute, ProtectedRoute } from '../../util/route_util';
import logo from '../../../app/assets/images/logo_white.png';

const Header = ({ currentUser, logout }) => {
  const loggedOut = () => (
    <header className="nav-bar-container">
      <nav className="nav-bar">
        <Link to="/" className="logo">
          <h1>lifenovel</h1>
        </Link>
        <Route to="/login" component={LoginFormContainer} />
      </nav>
    </header>
  )
  const loggedIn = () => (
    <header className="user-nav-bar-container">
      <nav className="user-nav-bar">
        <div className="left-nav-bar">
          <Link to="/" >
            <img id="home" src={ logo } />
          </Link>
          <SearchBarContainer />
        </div>
        <div className="right-nav-bar flex">
          <div>
            { currentUser.first_name }
          </div>
          <div>
            Home
          </div>
          <div>
            Create
          </div>
          <div>
            <i className="fas fa-user-friends nav-icon"></i>
          </div>
          <div>
            <i className="fab fa-facebook-messenger nav-icon"></i>
          </div>
          <div>
            <i className="fas fa-bell nav-icon"></i>
          </div>
          <div>
            <i className="fas fa-question-circle nav-icon"></i>
          </div>
          <div>
            <i className="fas fa-caret-down nav-icon"></i>
          </div>
          <div>
            <button className="header-btn" onClick={ logout }>Logout</button>
          </div>
        </div>
      </nav>
    </header>
  )
  return currentUser ? loggedIn() : loggedOut();

}

        // <SearchContainer />

export default Header;
