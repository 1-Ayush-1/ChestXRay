import axios from 'axios';
import React, { useCallback, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import './EditPat.css';

const EditPat = () => {
  const { userId } = useParams();
  const [patient, setPatient] = useState({});
  const navigate = useNavigate();

  const fetchPatientDetails = useCallback(() => {
    axios.get(`http://51.20.3.117/users/get-pat/${userId}`)
      .then(response => {
        if (response.data.success) {
          setPatient(response.data.patient);
        } else {
          console.error('Unexpected response format:', response.data);
        }
      })
      .catch(error => console.error('Error fetching Patient details:', error));
  }, [userId]);

  useEffect(() => {
    fetchPatientDetails();
  }, [fetchPatientDetails]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setPatient(prevPatient => ({ ...prevPatient, [name]: value }));
  };

  const handleSave = () => {
    axios.put(`http://51.20.3.117/users/update-pat/${userId}`, patient)
      .then(() => {
        navigate('/Home/ViewP');
      })
      .catch(error => console.error('Error updating patient:', error));
  };

  return (
    <div>
      <div className="ContainerEdit">
      <h3>Edit Patient</h3>
      <label>
        Name : <br/>
      <input
        type="text"
        name="name"
        value={patient.name || ''}
        onChange={handleInputChange}
        placeholder="Name"
      />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Mobile No: <br/>
      
      <input
        type="text"
        name="mobile_num"
        value={patient.mobile_num || ''}
        onChange={handleInputChange}
        placeholder="Mobile No"
      />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Email : <br/>
  <input
  name="email"
  type="email"  // Specifies the type as email
  value={patient.email || ''}  // Changed from doctor.about to doctor.email
  onChange={handleInputChange}
  placeholder="Enter your email"
/>
</label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<label>
        Date of Birth: <br/>
        <input
          name="dob"
          type="date"  // Specifies the type as date
          value={patient.dob}
          onChange={handleInputChange}
          placeholder="YYYY-MM-DD"
        />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Sex: <br/>
        <select
          name="sex"
          value={patient.sex}
          onChange={handleInputChange}
        >
          <option value="">Select</option>
          <option value="M">Male</option>
          <option value="F">Female</option>
          <option value="O">Other</option>
        </select>
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Address: <br/>
        <input
          name="address"
          type="text"
          value={patient.address}
          onChange={handleInputChange}
          placeholder="Enter your address"
        />
      </label>
<br/><br/>
      <label>
        Pincode: <br/>
        <input
          name="pincode"
          type="text"  // Specifies the type as text
          maxLength="6"  // Limits input length to 6 characters
          value={patient.pincode}
          onChange={handleInputChange}
          placeholder="Enter pincode"
        />
      </label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Occupation: <br/>
        <select
          name="occupation"
          value={patient.occupation}
          onChange={handleInputChange}
        >
          <option value="Pat">Patient</option>
          <option value="Doc">Doctor</option>
        </select>
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;


      <label>
        Profile Photo: <br/>
      
      <input
        type="file"
        name="profile_photo"
        
        onChange={handleInputChange}
        placeholder="Profile Photo"
      />
</label>


      <label>
        Medication: <br/>
        <input
          name="medication"
          type="text"  // Specifies the type as text
         
          value={patient.medication}
          onChange={handleInputChange}
          placeholder="Enter Medication"
        />
      </label>

      <label>
        Weight: <br/>
        <input
          name="weight"
          type="number"  // Specifies the type as text
         
          value={patient.weight}
          onChange={handleInputChange}
          placeholder="Enter weight"
        />
      </label>
      
      <label>
        Height : <br/>
        <input
          name="height"
          type="number"  // Specifies the type as text
          value={patient.height}
          onChange={handleInputChange}
          placeholder="Enter height"
        />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <br/> <br/> <br/> <br/>
      <button className="Save"  onClick={handleSave}>Save</button>
      <button className="Cancel" onClick={() => navigate('/Home/ViewP')}>Cancel</button>
      </div>
    </div>
  );
};

export default EditPat;