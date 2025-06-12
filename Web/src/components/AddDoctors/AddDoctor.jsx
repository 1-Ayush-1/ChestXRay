import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import './AddDoctor.css';

const AddDoctor = () => {
  const [doctor, setDoctor] = useState({
    name: '',
    mobile_num: '',
    about: '',
    email: '',
    dob: '',
    sex: '',
    address: '',
    pincode: '',
    description: '',
    profile_photo: null,  // Initialize profile_photo as null for file upload handling
  });

  const navigate = useNavigate();

  const handleChange = (e) => {
    if (e.target.name === 'profile_photo') {
      setDoctor({ ...doctor, profile_photo: e.target.files[0] }); // Capture the file object
    } else {
      setDoctor({ ...doctor, [e.target.name]: e.target.value });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Create FormData object to send file data
    const formData = new FormData();
    formData.append('name', doctor.name);
    formData.append('mobile_num', doctor.mobile_num);
    formData.append('about', doctor.about);
    formData.append('email', doctor.email);
    formData.append('dob', doctor.dob);
    formData.append('sex', doctor.sex);
    formData.append('address', doctor.address);
    formData.append('pincode', doctor.pincode);
    formData.append('description', doctor.description);
    formData.append('profile_photo', doctor.profile_photo); // Append the file object

    try {
      const response = await axios.post('http://51.20.3.117/api/users/add-doc/', formData, {
        headers: {
          'Content-Type': 'multipart/form-data', // Important to set this header for file uploads
        },
      });

      console.log('Doctor added successfully:', response.data);
      navigate('/Home');
    } catch (error) {
      console.error('There was an error adding the doctor:', error);
    }
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Name:</label>
          <input
            type="text"
            name="name"
            value={doctor.name}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Mobile:</label>
          <input
            type="tel"
            name="mobile_num"
            value={doctor.mobile_num}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>About:</label>
          <textarea
            name="about"
            value={doctor.about}
            onChange={handleChange}
          />
        </div>
        <div>
          <label>Email:</label>
          <input
            type="email"
            name="email"
            value={doctor.email}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Date of Birth:</label>
          <input
            type="date"
            name="dob"
            value={doctor.dob}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Profile Photo:</label>
          <input
            type="file"
            name="profile_photo"
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Sex:</label>
          <select
            name="sex"
            value={doctor.sex}
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
            value={doctor.address}
            onChange={handleChange}
          />
        </div>
        <div>
          <label>Pincode:</label>
          <input
            type="text"
            name="pincode"
            value={doctor.pincode}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Description:</label>
          <textarea
            name="description"
            value={doctor.description}
            onChange={handleChange}
          />
        </div>
        <button type="submit">Add Doctor</button>
      </form>
    </div>
  );
};

export default AddDoctor;
