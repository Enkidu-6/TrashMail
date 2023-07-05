import React from "react";
import TitleBar from "../TitleBar";
import ButtonSection from "../ButtonSection";
import Generate from "../Generate";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

const Inbox = () => {
  const [lastEmail, setLastEmail] = useState();
  const navigate = useNavigate();

  useEffect(() => {
    setLastEmail(localStorage.getItem("lastEmailId"));
    console.log(lastEmail);
  }, []);

  useEffect(() => {
    if (lastEmail) {
      navigate(`/inbox/${lastEmail}`);
    }
  }, [lastEmail]);
  

  return (
    <div>
      <Generate />
    </div>
  );
};

export default Inbox;