import React from 'react';
import Container from 'react-bootstrap/Container';
import Navbar from 'react-bootstrap/Navbar';
import { useNavigate } from 'react-router-dom';
import Doc from '../../images/Doctor.jpeg';
import Pat from '../../images/Patient.jpeg';
const Home = ()=> {
const navigate=useNavigate();
const PatientClick = () => {
    navigate('ViewP');
};
const DoctorClick = () => {
  navigate('ViewD');
};
const AddDoctorClick=()=>{
  navigate('AddD')
}
const AddPatientClick=()=>{
  navigate('AddP')
}
  
  return (
    <div>
<Navbar expand="lg" className="bg" text='center'>
    <Container>
      <Navbar.Brand  className="welcome" href="">WELCOME</Navbar.Brand>
    </Container>
  </Navbar>
  <br/>
  <br/>
  <br/>

<div className='row mt-50'>
  <div className='col-lg-3'>
  <img src={Pat} alt="Patient" onClick={PatientClick}/>
<h3>VIEW ALL PATIENT</h3>
  </div>
  <div className='col-lg-3'>
  <img src={Doc} alt="Doctor" onClick={DoctorClick}/>
  <h3>VIEW ALL DOCTOR</h3>
  </div>
  <div className='col-lg-3'>
  <img src={Pat} alt="Patient" onClick={AddPatientClick}/>
<h3> ADD A PATIENT</h3>
  </div>
  <div className='col-lg-3'>
  <img src={Doc} alt="Doctor" onClick={AddDoctorClick}/>
<h3>ADD A DOCTOR</h3>
  </div>
</div>
</div>
  )
}

export default Home;