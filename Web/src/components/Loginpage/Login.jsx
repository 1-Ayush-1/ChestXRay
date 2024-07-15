import axios from 'axios';
import React, { useState } from 'react';
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import { useNavigate } from 'react-router-dom';
import './Login.css';

const Login = () => {

 // Default cookie name for CSRF token

  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error,setError]=useState('');
const navigate = useNavigate();
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
const response =await axios.post('http://51.20.3.117/auth/staff-login/',
{
    UserName: username,
    UserPassword: password,
});
const data = response.data;

      if (data.success){
        navigate('/Home');
      } else {
        setError(data.message);
      }
    } catch (error) {
      console.error('Login failed:', error);
      setError('Login failed. Please try again !');
    }
  };

  return (
    <div>
  <Navbar expand="lg" className="bg" text='center'>
    <Container>
      <Navbar.Brand href="">Chest XRay Analysis Admin</Navbar.Brand>
      <Navbar.Toggle aria-controls="basic-navbar-nav" />
      <Navbar.Collapse id="basic-navbar-nav">
        <Nav className="me-auto ml-auto"> 
          <Nav.Link href="About">About us</Nav.Link>
          <Nav.Link href="Contact">Contact Us</Nav.Link>

        </Nav>
      </Navbar.Collapse>
    </Container>
  </Navbar>
      <div className='adduser'>
        <h2>ADMIN LOGIN </h2>
        <form className='adduserform' onSubmit={handleSubmit} >
          <div className='input-group'>
            <label htmlFor='email'>Username :</label>
            <input
              type='text'
              id='Username'
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder='Enter your Username'
              autoComplete='off'
            />
            <br/>

            <label htmlFor = 'password'>Password :</label>
            <input
              type='password'
              id='password'
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder='Enter your password'
              autoComplete='off'
            />

<button type='submit' variant="outline-success">LOGIN</button>
          </div>
        </form>
        <p className='error-message'>{error}</p>
      </div>
      </div>
  );
};
export default Login;