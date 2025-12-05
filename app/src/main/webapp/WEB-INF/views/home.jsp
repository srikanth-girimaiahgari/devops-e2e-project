<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List"%>
<%@ page import="com.bandbooking.models.Band"%>
<html>
<head>
    <link rel="stylesheet" href="<c:url value='/static/css/styles.css'/>">
    <title>Music Band Booking - Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #215f3b;
            background-size: cover;
            background-repeat: no-repeat;
        }

        h2 {
            text-align: left;
            color: #e7e2e2;
        }

        h1 {
            text-align: left;
            color: rgb(233, 235, 241);
        }

        .container {
            width: 600px;
            margin: 0 auto;
            padding: 90px;
            background-color: #215f3b;
            border-radius: 20px;
            box-shadow: 0 0px 0px rgba(0, 0, 0, 0.1);
            position: absolute;
            top: 35%;
            left: 25%;
            transform: translate(-50%, -50%);
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: rgb(233, 235, 241);

        }

        input[type="text"],
        input[type="tel"],
        input[type="email"],
        input[type="password"] {
            width: 60%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        .button-container {
            display: flex;
            gap: 10px; /* Optional: Adds space between the buttons */
        }

        button[type="submit"],
        .signup-link {
            display: inline-block;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
        }

        button[type="submit"]:hover,
        .signup-link:hover {
            background-color: #0056b3;
        }

        .signup-link a {
            color: #fff;
            text-decoration: none;
        }

        .signup-link a:hover {
            color: #fff; /* Keeps the text color on hover */
        }

    </style>
</head>
<body>
<div class="container">
    <h1>Available Bands</h1>
    <div class="band-list">
        <c:forEach var="band" items="${bands}">
            <div class="band-card">
                <img src="<c:url value='/static/images/${band.image}'/>" alt="${band.name}">
                <h3>${band.name}</h3>
                <p>Owner: ${band.ownerName}</p>
                <p>Contact: ${band.contactNumber}</p>
                <p>Address: ${band.address}</p>
                <a href="booking?bandId=${band.id}">Book Now</a>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
