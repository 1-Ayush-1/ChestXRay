import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import './ViewDoctors.css';

const ViewDoctors = () => {
  const [doctors, setDoctors] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    fetchDoctors();
  }, []);

  const fetchDoctors = () => {
    axios.get('http://51.20.3.117/api/users/doctor-view/')
      .then(response => {
        if (response.data.success && Array.isArray(response.data.doctors)) {
          setDoctors(response.data.doctors);
        } else {
          console.error('Unexpected response format:', response.data);
        }
      })
      .catch(error => console.error('Error fetching doctors:', error));
  };

  const handleDelete = (id) => {
    if (window.confirm("Are you sure you want to delete the doctor's license?")) {
      axios.delete(`http://51.20.3.117/api/users/delete-doc/${id}`)
        .then(() => fetchDoctors())
        .catch(error => console.error('Error deleting doctor:', error));
    }
  };

  const handleEdit = (userId) => {
    navigate(`/Home/ViewD/EditD/${userId}`);
  };

  return (
    <div>
      <h2>Doctor List</h2>
      <ul>
        {doctors.map(doctor => (
          <li key={doctor.user_id}>
            <strong>{doctor.name}</strong> <br />
            Mobile: {doctor.mobile_num} <br />
            About: {doctor.about} <br />
            <button onClick={() => handleEdit(doctor.user_id)}>Edit</button>
            <button onClick={() => handleDelete(doctor.user_id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ViewDoctors;
