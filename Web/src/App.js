import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'; // Import BrowserRouter and Routes
import './App.css';
import About from './components/Aboutpage/About';
import Contact from './components/Contactpage/Contact';
import ViewDoctors from './components/ViewDoctors/ViewDoctors';
import Home from './components/Homepage/Home';
import Login from './components/Loginpage/Login';
import ViewPatients from './components/ViewPatients/ViewPatients';
import AddDoctor from './components/AddDoctors/AddDoctor';
import AddPatients from './components/AddPatients/AddPatients';
import EditDoc from './components/EditDoc/EditDoc';
import EditPat from './components/EditPat/EditPat';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/Home" element={<Home />} />
        <Route path="/About" element={<About />} />
        <Route path="/Contact" element={<Contact />} />
        <Route path="/Home/ViewP" element={<ViewPatients />} />
        <Route path="/Home/ViewD" element={<ViewDoctors />} />
        <Route path="/Home/AddD" element={<AddDoctor />} />
        <Route path="/Home/AddP" element={<AddPatients />} />
        <Route path="/Home/ViewD/EditD/:userId" element={<EditDoc />} />
        <Route path="/Home/ViewP/EditP/:userId" element={<EditPat />} />
      </Routes>
    </Router>
  );
}

export default App;
