
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import './ViewPatients.css';

const ViewPatients = () => {
    const [patients, setPatients] = useState([]);
    const navigate = useNavigate();
  
    useEffect(() => {
      fetchPatients();
    }, []);
  
    const fetchPatients = () => {
      axios.get('http://51.20.3.117/users/patient-view/')
        .then(response => {
          if (response.data.success && Array.isArray(response.data.patients)) {
            setPatients(response.data.patients);
          } else {
            console.error('Unexpected response format:', response.data);
          }
        })
        .catch(error => console.error('Error fetching Patients:', error));
    };
  
    const handleDelete = (id) => {
      if (window.confirm("Are you sure you want to delete the Patient?")) {
        axios.delete(`http://51.20.3.117/users/delete-pat/${id}`)
          .then(() => fetchPatients())
          .catch(error => console.error('Error deleting Patient:', error));
      }
    };
  
    const handleEdit = (userId) => {
      navigate(`/Home/ViewP/EditP/${userId}`);
    };
  
    return (
      <div>
        <h2>Patient List</h2>
        <ul>
          {patients.map(patient => (
            <li key={patient.user_id}>
              <strong>{patient.name}</strong> <br />
              Mobile: {patient.mobile_num} <br />
              <button className="map" onClick={() => handleEdit(patient.user_id)}>Edit</button>
              <button className="map" onClick={() => handleDelete(patient.user_id)}>Delete</button>
            </li>
          ))}
        </ul>
      </div>
    );
  };
  

export default ViewPatients
