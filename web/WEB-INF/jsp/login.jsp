<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%
    if (session.getAttribute("usuario") != null) {
        response.sendRedirect("index.htm");
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Fira+Sans" rel="stylesheet">
        <style type="text/css">



            .input-usuario-icon{
                background-image:url(images/ico-usuario-azul.png);
                background-repeat: no-repeat;
                position:relative;
                background-size: 12px;
                padding-left: 50px;
                font-family: EF Lucida Sans;
                font-size: 18px;
                background-position: 15px center;
            }

            .input-pass-icon{
                background-image:url(images/ico-candado-azul.png);
                background-repeat: no-repeat;
                background-size: 12px;
                padding-left: 50px;
                font-family: EF Lucida Sans;
                font-size: 18px;
                background-position: 15px center;
            }

            .btn-ingresar{
                background-color: #ED8300; 
                border-radius: 10px;
                border: none;
            }

          

        </style>
        <title>Sistema Arcos</title>
    </head>

    <div class="container">    
        
        
            <div class="row" style="height: 90%; margin-top:5%; margin-bottom: 5%;">
                <div class="col-md-1"></div>
                <div class="col-md-10"  >
                    <div class="row">
                        <div class="col-md-6" style="background-color:#EAEAEA ; border: 2px solid #FFFFFF;border-radius: 20px 0px 0px 20px; padding-right: -5px;">

                            <div class="container">

                                <div class="row" style="margin-top:40px;">
                                    <div class="col-md-4"></div>
                                    <div class="col-md-4">

                                        <div style="font-family: 'Fira Sans',sans-serif;font-size: 14px;"><b>Bienvenido a</b></div>

                                    </div>
                                    <div class="col-md-4"></div>
                                </div>
                                <div class="row">
                                    <div class="col-md-7">

                                        <img  src="images/logo-kiotrack-color.png" style="height: 33px; width: 239px;" alt="kiotrack-logo-login">

                                    </div>
                                    <div class="col-md-5" >
                                        <div class="row">
                                            <div class="col-md-1">

                                                <img  src="images/barra-sis_arcos.png" alt="kiotrack-logo-login" style="width: 3px; 
                                                      height: 36px; ">

                                            </div>
                                            <div class="col-md-10" style="padding-left: 0px;">

                                                <div style="font-size: 14px;font-family: 'Semi-bold 600', sans-serif;"><b>SISTEMA DE <br>MONITOREO DE ARCOS</b></div>

                                            </div>
                                        </div>


                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-12">
                                        <p style="font-size: 14px;font-family: 'Fira Sans Regular 10PT', sans-serif;">Para ingresar al sistema es necesario ingresar su nombre de usuario y contraseña</p>
                                    </div>
                                </div>

                                <form class="input-usuario" action="<c:url value="login.htm" />" method="POST">
                                    <input type="text" class="form-control input-usuario-icon" name="inputUsuario" placeholder="nombre de usuario" required>
                                    <br>
                                    <input type="password" class="form-control input-pass-icon" name="inputPassword" placeholder="contraseña" required>
                                    <br>
                                    <button type="submit" class="btn btn-primary col-sm-12 btn-ingresar">INGRESAR AHORA</button>
                                    <br><br>

                                    <p style="font-size: 14px;font-family: 'Fira Sans Regular 10PT',sans-serif;">Tiene problemas para ingresar al sistema? <br>favor de ingresar <a href="#">aqui</a></p>
                                </form>


                            </div>
                        </div>
                        <div class="col-md-6" style="padding-left: 0px;" >
                            <img src="images/img-background-autos-login.png" alt="" style="max-width: 100%;
                                 max-height: 100%;">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
          

    </div>
</html>
