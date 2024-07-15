import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import './AddPatients.css';

const AddPatient = () => {
  const [patient, setPatient] = useState({
    name: '',
    mobile_num: '',
    email: '',
    dob: '',
    sex: '',
    address: '',
    pincode: '',
    medication:'',
    weight:'',
    height:'',
    profile_photo: null  // Change to null for file upload handling
  });

  const navigate = useNavigate();

  const handleChange = (e) => {
    if (e.target.name === 'profile_photo') {
      setPatient({ ...patient, profile_photo: e.target.files[0] }); // Capture the file object
    } else {
      setPatient({ ...patient, [e.target.name]: e.target.value });
    }
  };

  const handleSubmit = async (e) => {

    e.preventDefault();
    console.log('Profile Photo:', patient.profile_photo);
    // Create FormData object to send file data
    const formData = new FormData();
    formData.append('name', patient.name);
    formData.append('mobile_num', patient.mobile_num);
    formData.append('email', patient.email);
    formData.append('dob', patient.dob);
    formData.append('sex', patient.sex);
    formData.append('address', patient.address);
    formData.append('pincode', patient.pincode);
    formData.append('medication', patient.medication);
    formData.append('weight', patient.weight);
    formData.append('height', patient.height);
    formData.append('profile_photo', patient.profile_photo); // Append the file object
console.log(patient.profile_photo)
    try {
      const response = await axios.post('http://51.20.3.117/users/add-pat/', formData, {
        headers: {
          'Content-Type': 'multipart/form-data', // Important to set this header for file uploads
        },
      });

      console.log('Patient added successfully:', response.data);
      navigate('/Home');
    } catch (error) {
      console.error('There was an error adding the patient:', error);
    }
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        {/* Your form inputs here */}
        <div>
          <label>Name:</label>
          <input
            type="text"
            name="name"
            value={patient.name}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Mobile:</label>
          <input
            type="tel"
            name="mobile_num"
            value={patient.mobile_num}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Email:</label>
          <input
            type="email"
            name="email"
            value={patient.email}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Date of Birth:</label>
          <input
            type="date"
            name="dob"
            value={patient.dob}
            onChange={handleChange}
            required
          />
        </div>

        <div>
          <label>Profile Photo:</label>
          <input
            type="file"
            name="profile_photo"
            onChange={handleChange} // Capture file changes
            required
          />
        </div>

        <div>
          <label>Sex:</label>
          <select
            name="sex"
            value={patient.sex}
            onChange={handleChange}
            required
          >
            <option value="">Select</option>
            <option value="M">Male</option>
            <option value="F">Female</option>
            <option value="O">Other</option>
          </select>
        </div>

        <div>
          <label>Address:</label>
          <textarea
            name="address"
            value={patient.address}
            onChange={handleChange}
          />
        </div>

        <div>
          <label>Pincode:</label>
          <input
            type="text"
            name="pincode"
            value={patient.pincode}
            onChange={handleChange}
            required
          />
        </div>

        <div>
          <label>Medication:</label>
          <textarea
            name="medication"
            value={patient.medication}
            onChange={handleChange}
          />
        </div>

        <div>
          <label>Weight:</label>
          <input
            name="weight"
            type="number"
            value={patient.weight}
            onChange={handleChange}
          />
        </div>

        <div>
          <label>Height:</label>
          <input
            type="number"
            name="height"
            value={patient.height}
            onChange={handleChange}
          />
        </div>

        <button type="submit">Add Patient</button>
      </form>
    </div>
  );
};

export default AddPatient;