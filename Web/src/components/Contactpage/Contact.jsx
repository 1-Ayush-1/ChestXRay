import React from 'react';
import { FaPhone } from "react-icons/fa";
import { HiOfficeBuilding } from "react-icons/hi";
import { IoHome } from "react-icons/io5";
const   Contact = () => {
  return (
    <div>
    <h1>Staff members</h1><br />
    <div>
        <FaPhone size={40}/><br/>
        <h8>CONTACT NUMBER</h8><br/>
        <a href='tel:+91 8897245002'>
        +91 8897245002
        </a>
        </div>
    <br/>
    <br/>

        <div >
        <IoHome size={48} />
        <h6>OFFICE ADDRESS</h6>
        <a href='https://maps.app.goo.gl/FubLEwy8P3Bv2XUB6'>
        BITS PILANI PILANI CAMPUS </a>
        </div>
<br/>
<br/>
  <h4>STAFF MEMBERS</h4>
  <p>
    N.Abhiram <br/>
    Sourish Ambati<br/>
    Uday venkata<br/>
    Harsha Aravind<br/>
    Anudheer<br/>
  </p>
<br/>
<div>
<HiOfficeBuilding size={50}/>
<h5>Office Hours</h5>
<p>
  9:00 AM - 7.30 PM
</p>

</div>
    </div>
  )
}

export default Contact
