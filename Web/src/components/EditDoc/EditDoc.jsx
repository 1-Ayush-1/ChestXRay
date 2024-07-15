import axios from 'axios';
import React, { useCallback, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import './EditDoc.css';

const EditDoc = () => {
  const { userId } = useParams();
  const [doctor, setDoctor] = useState({});
  const navigate = useNavigate();

  const fetchDoctorDetails = useCallback(() => {
    axios.get(`http://51.20.3.117/users/get-doc/${userId}`)
      .then(response => {
        if (response.data.success) {
          setDoctor(response.data.doctor);
        } else {
          console.error('Unexpected response format:', response.data);
        }
      })
      .catch(error => console.error('Error fetching doctor details:', error));
  }, [userId]);

  useEffect(() => {
    fetchDoctorDetails();
  }, [fetchDoctorDetails]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setDoctor(prevDoctor => ({ ...prevDoctor, [name]: value }));
  };

  const handleSave = () => {
    axios.put(`http://51.20.3.117/users/update-doc/${userId}`, doctor)
      .then(() => {
        navigate('/Home/ViewD');
      })
      .catch(error => console.error('Error updating doctor:', error));
  };

  return (
    <div>
      <div className="ContainerEdit">
      <h3 className="i">Edit Doctor</h3>
      <label>
        Name : <br/>
      <input
        type="text"
        name="name"
        value={doctor.name || ''}
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
        value={doctor.mobile_num || ''}
        onChange={handleInputChange}
        placeholder="Mobile No"
      />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        About : <br/>
      <textarea
        name="about"
        value={doctor.about || ''}
        onChange={handleInputChange}
        placeholder="About"
      />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Email : <br/>
  <input
  name="email"
  type="email"  // Specifies the type as email
  value={doctor.email || ''}  // Changed from doctor.about to doctor.email
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
          value={doctor.dob}
          onChange={handleInputChange}
          placeholder="YYYY-MM-DD"
        />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Sex: <br/>
        <select
          name="sex"
          value={doctor.sex}
          onChange={handleInputChange}
        >
          <option value="">Select</option>
          <option value="M">Male</option>
          <option value="F">Female</option>
          <option value="O">Other</option>
        </select>
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<br/>
<br/>
      <div>
          <label>Profile Photo:</label>
          <input
          type="file"
            name="profile_photo"
            value={doctor.profile_photo||""}
            onChange={handleInputChange}
            placeholder='Profile Photo'
          />
        </div>
<br/>


      <label>
        Address: <br/>
        <input
          name="address"
          type="text"
          value={doctor.address}
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
          value={doctor.pincode}
          onChange={handleInputChange}
          placeholder="Enter pincode"
        />
      </label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Occupation: <br/>
        <select
          name="occupation"
          value={doctor.occupation}
          onChange={handleInputChange}
        >
          <option value="Pat">Patient</option>
          <option value="Doc">Doctor</option>
        </select>
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label>
        Description: <br/>
        <textarea
          name="description"
          value={doctor.description}
          onChange={handleInputChange}
          placeholder="Enter description"
        />
      </label>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <br/> <br/> <br/> <br/>
      </div>

      <button className="SaveD" onClick={handleSave}>Save</button>
      <button className="CancelD" onClick={() => navigate('/Home/ViewD')}>Cancel</button>
    </div>
  );
};

export default EditDoc;