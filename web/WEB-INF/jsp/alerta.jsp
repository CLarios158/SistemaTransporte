<%@page import="Config.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <title>Sistema de Monitoreo</title>
        <!--<script defer
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAdTfw1waJScSYaMdXKGqAW6rnHcwmjZwc">
        </script>-->

        <!--link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"/-->
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
        <!--<link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />-->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.7.1/css/bootstrap-datepicker.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/datatables.css">
        <link rel="stylesheet" href="css/main.css" />
        
 
    </head>

    <body class="theme-dark">
        <!-- top bar -->
        <nav class="main-navbar navbar navbar-expand-lg">
            <a class="navbar-brand" href="/Sis_Arcos/index.htm">
                <img class="img-fluid" src="images/logo-kiotrack-blanco.png" alt="kiotrack-logo">
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#mainNavContent"
                    aria-controls="mainNavContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="main-navbar_content collapse navbar-collapse" id="mainNavContent">
                <ul class="navbar-nav">
                    <li class="nav-item center">
                        Sistema de Monitoreo de Transporte Público
                    </li>
                </ul>
                <ul class="main-navbar_options navbar-nav">
                    <li class="nav-item center">
                        <button class="btn btn-mute-action" onclick="this.classList.toggle('muted')">
                            <div class="mn-option-icon"></div>
                            <span class="mn-option-text-sm">silenciar <br> asistente</span>
                        </button>
                    </li>
                    <li class="nav-item d-flex center">
                        <div>
                            <span class="d-block"> <%= session.getAttribute("usuario")%> </span>
                            <a class="mn-logout-link" href="<c:url value="logout.htm" />">Cerrar sesión</a>
                        </div>
                        <div class="mn-option-profile-img">
                            <img width="50px" height="50px" style="border-radius: 20px;" src="images/persona.png" alt="user">
                            <!--<i class="fas fa-user-circle"></i>-->
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- end topbar -->
        <nav class="content-navbar">
            <div class="container-fluid">
                <div class="row no-gutters">
                    <div class="col-md-2">
                        <div class="cn-wrapper no-border">
                            <a class="cn-bars d-flex flex-no-wrap align-items-center" href="" data-toggle="slide-menu"
                               data-target="#main-slide-nav">
                                <i class="fas fa-bars"></i>
                                <div class="cn-title">
                                    <h5>MENU</h5>
                                </div>
                            </a>
                        </div>
                    </div>

                    <!-- AQUI SE PONE EL PORCENTAJE DE CRITICO, ALERTA, INFORMATIVO -->

                    <div class="col-md-5">
                    </div>      

                    <div class="col-md-5">
                    </div>


                </div>
            </div>
        </nav>

        <main style="background-color: #05151C;">
            <!-- main slide nav -->
            <div class="slide-menu main-slide-nav" id="main-slide-nav">

                <nav class="nav navigator flex-column">
                    <a class="nav-link active" href="index.htm"><i class="fas fa-home"></i> HOME</a>
                    <ul id="menu" class="menu">
                        <li><a class="nav-link" href="#"><i class="fas fa-map-marker-alt"></i>  GPS <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="asociar_gps.htm"><i class="fas fa-arrows-alt-h"></i>ASOCIAR GPS</a></li>
                                <li><a class="nav-link" href="consultar_gps.htm"><i class="fas fa-search"></i>CONSULTAR INFORMACIÓN</a></li>
                                <li><a class="nav-link" href="eliminar_gps.htm"><i class="fas fa-trash-alt"></i>ELIMINAR INFORMACIÓN</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="#"><i class="far fa-window-restore"></i>CAPAS <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="crear_capa.htm"><i class="fas fa-plus-circle"></i>CREAR NUEVA CAPA</a></li>
                                <li><a class="nav-link" href="consultar_capa.htm"><i class="fas fa-search"></i>CONSULTAR CAPA</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="#"><i class="fas fa-road"></i>RUTAS <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="crear_ruta.htm"><i class="fas fa-plus-circle"></i>CREAR NUEVA RUTA</a></li>
                                <li><a class="nav-link" href="consultar_ruta.htm"><i class="fas fa-search"></i>CONSULTAR RUTA</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="#"><i class="fas fa-map-marker-alt"></i> RAMALES <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="crear_ramal.htm"><i class="fas fa-plus-circle"></i>CREAR NUEVA RAMAL</a></li>
                                <li><a class="nav-link" href="consultar_ramal.htm"><i class="fas fa-search"></i>CONSULTAR RAMAL</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link"  href="#"><i class="fas fa-clipboard-list"></i> ITINERARIOS <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="crear_itinerario.htm"><i class="fas fa-plus-circle"></i>CREAR NUEVO ITINERARIO</a></li>
                                <li><a class="nav-link" href="consultar_itinerario.htm"><i class="fas fa-search"></i>CONSULTAR ITINERARIO</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link"  href="#"><i class="fas fa-file-alt"></i> REPORTES <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="reporte_alerta.htm"><i class="fas fa-exclamation-triangle"></i>ALERTAS</a></li>
                                <li><a class="nav-link" href="reporte_parada.htm"><i class="fas fa-map-marker-alt"></i>   PARADAS</a></li>
                                <li><a class="nav-link" href="reporte_vuelta.htm"><i class="fas fa-file-alt"></i> RESUMEN DE VUELTAS</a></li>
                                <li><a class="nav-link" href="reporte_evaluar_unidad.htm"><i class="fas fa-bus"></i>EVALUAR UNIDADES</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="alerta.htm" ><i class="fas fa-exclamation-triangle"></i>ALERTAS</a></li>                        
                        <li><a class="nav-link" href="configurar_alerta.htm" ><i class="fas fa-cog"></i>CONFIGURACIÓN ALERTAS</a></li>
                    </ul>
                </nav>
            </div>
            
            <!-- content -->        
            <div class="form-group">
                <nav class="nav nav-horizontal flex-row">
                    <a class="color-label" href="alerta.htm"><i class="fas fa-home color-icon"></i>Alertas</a>
                </nav>
                <div class="line"></div>
            </div>
            <div class="form-group center">
                <label class="text-white">Alertas del día <label style="color: #5EC7FF;">Unidad <label id="no_unidad" style="color: #5EC7FF;"></label></label></label>
            </div>
            <div class="form-group center">
                <label style="font-size: 12px;" for="unidad" class=" col-form-label text-white">Buscar unidad:</label>
                <div class="col-sm-3 input-icons">
                    <i class="fas fa-search icon-input"></i>
                    <input type="text" class="form-control" name="buscarUnidad" id="buscarUnidad" autocomplete="off">
                    <div style="z-index: 2; position: absolute; width: 90%;" class="list-group" id="show-list"></div>
                </div>
                <input id="niv" hidden />
            </div>
            <div id="mostrar-tablas" class="row" style="margin: 0px; display: none;">
                <div class="col">
                    <div id="mostrar-tabla-unidad"></div>
                </div>
                <div class="col">
                    <div id="mostrar-tabla-alcancia"></div> 
                </div>
            </div>
        </main>

        <footer>
            <div class=" container">
                <div class="row">
                    <div class="col-md-2 center">
                        <img class="img-fluid" src="images/logo-kiotrack-color.png" alt="">
                    </div>
                    <div class="col-md-10">
                        <p>
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent imperdiet quis quam ut
                            aliquet. Maecenas sit amet mi suscipit, molestie sapien vel, tristique dui. Morbi varius,
                            odio
                            in suscipit ultricies, turpis diam sollicitudin nisl, non maximus risus elit ullamcorper
                            dolor.
                        </p>
                    </div>
                </div>
            </div>
        </footer>

        <!-- circular-menu -->
        <div id="circularMenu" class="circular-menu">
            <a class="floating-btn noselect"
               onclick="document.getElementById('circularMenu').classList.toggle('active');">
                <img src="images/ico-kiotrack-isotipo-2.png" alt="">
            </a>

            <menu class="items-wrapper">
                <a href="#" class="menu-item"><i class="fas fa-bus"></i></a>
                <a href="#" class="menu-item"><i class="fas fa-taxi"></i></a>
                <a href="#" class="menu-item"><i class="fas fa-traffic-light"></i></a>
                <a href="arcos/" class="menu-item"><img src="images/ico-arcos-white.png" alt=""></a>
                <a href="arcos/" class="menu-item"><i class="fas fa-archway"></i></a>
            </menu>
        </div>
        <!-- end circular-menu -->
        
        <!-- Modal Puntos de control en los que se paro la unidad -->
        <div class="modal fade" id="modalPuntosControl" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Puntos de control en los que se paro la unidad</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioPControl" id="inicioPControl"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="finPControl" id="finPControl"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-PControl" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaPuntosControl" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Punto de Control</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Paradas obligatorias no realizadas -->
        <div class="modal fade" id="modaltablaParadasO" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Paradas obligatorias no realizadas</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioPObligatoria" id="inicioPObligatoria"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finPObligatoria" id="finPObligatoria"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-PObligatoria" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaParadasO" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Parada obligatoria</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Incumplimiento de itinerario -->
        <div class="modal fade" id="modalITiempo" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Incumplimiento de itinerario</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioItinerario" id="inicioItinerario"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finItinerario" id="finItinerario"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-Itinerario" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaITiempo" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora itinerario</th>
                                    <th>Hora reg</th>
                                    <th>Fecha</th>
                                    <th>Parada obligatoria</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Incumplimiento de recorrido -->
        <div class="modal fade" id="modalIRecorrido" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body" >
                        <div class="row form-group center">
                            <h6 class="text-white">Incumplimineto de recorrido</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioIRecorrido" id="inicioIRecorrido"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finIRecorrido" id="finIRecorrido"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-IRecorrido" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaIRecorrido" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ruta</th>
                                    <th>Ramal</th>
                                    <th>Ubicación de Desviación</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Exceso de velocidad -->
        <div class="modal fade" id="modalEVelocidad" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Exceso de velocidad</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioEVelocidad" id="inicioEVelocidad"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finEVelocidad" id="finEVelocidad"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-EVelocidad" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaEVelocidad" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Velocidad</th>
                                    <th>Ubicación</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Unidad fuera de conexión -->
        <div class="modal fade" id="modalFConexion" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Unidad fuera de conexión</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioFConexion" id="inicioFConexion"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finFConexion" id="finFConexion"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-FConexion" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaFConexion" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ubicación</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Alcancía fuera de conexión -->
        <div class="modal fade" id="modalAFConexion" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Alcancía fuera de conexión</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioAFConexion" id="inicioAFConexion"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finAFConexion" id="finAFConexion"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-AFConexion" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaAFConexion" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ubicación</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Apertura de Puerta -->
        <div class="modal fade" id="modalAPuerta" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Apertura de puerta</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioAPuerta" id="inicioAPuerta"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finAPuerta" id="finAPuerta"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-APuerta" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaAPuerta" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ubicación</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Detección de tarjeta en lista negra -->
        <div class="modal fade" id="modalLNegra" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Detección de tarjeta en lista negra</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioLNegra" id="inicioLNegra"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finLNegra" id="finLNegra"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-LNegra" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaLNegra" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ubicación</th>
                                    <th>Tarjeta</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Papel térmico agotado -->
        <div class="modal fade" id="modalPTermico" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Papel térmico agotado</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioPTermico" id="inicioPTermico"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finPTermico" id="finPTermico"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-PTermico" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaPTermico" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ubicación</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
         <!-- Modal Detección de pago excesivo con tarjeta -->
        <div class="modal fade" id="modalPExcesivo" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Detección de pago excesivo con tarjeta</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioPExcesivo" id="inicioPExcesivo"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finPExcesivo" id="finPExcesivo"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-PExcesivo" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaPExcesivo" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ubicación</th>
                                    <th>Tarjeta</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
         
          <!-- Modal Alcancía por Llenarse -->
        <div class="modal fade" id="modalALlenarse" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Alcancía por llenarse</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" name="inicioALlenarse" id="inicioALlenarse"/>
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" name="finALlenarse" id="finALlenarse"/>
                            </div>
                            <div class="col-sm-2">
                                <button id="btn-ALlenarse" style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <table id="tablaALlenarse" class="table-alerta" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Número</th>
                                    <th>Hora</th>
                                    <th>Fecha</th>
                                    <th>Ubicación</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>  
                        <div class="center">
                            <button class="btn btn-outline-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
        <script
            src="https://code.jquery.com/jquery-3.4.1.js"
            integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
        crossorigin="anonymous"></script>  
        <script src="https://unpkg.com/gijgo@1.9.13/js/gijgo.min.js" type="text/javascript"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.7.1/js/bootstrap-datepicker.min.js"></script>
        <script src="javascript/vendors/datatables.min.js"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>
        <script src="https://unpkg.com/bootstrap-datepicker@1.9.0/dist/locales/bootstrap-datepicker.es.min.js" charset="UTF-8"></script>
        
        <!-- Menu -->
        <script type="text/javascript">
            $(document).ready(function () {
                $('.menu li:has(ul)').click(function (e) {
                    e.preventDefault();
                    if ($(this).hasClass('activado')) {
                        $(this).removeClass('activado');
                        $(this).children('ul').slideUp();
                    } else {
                        $('.menu li ul').slideUp();
                        $('.menu li').removeClass('activado');
                        $(this).addClass('activado');
                        $(this).children('ul').slideDown();
                    }
                });

                $('.menu li ul li a').click(function () {
                    window.location.href = $(this).attr("href");
                });
            });
        </script>
        
        <!-- Buscar Unidad -->
        <script type="text/javascript">
            $(document).ready(function () {
                $("#buscarUnidad").keyup(function(e){
                    e.preventDefault();
                   
                   var unidad = $(this).val();
                   if(unidad !== ''){
                       $.ajax({
                            url: 'buscar_unidad_alerta.htm',
                            type: "GET",
                            data: { unidad: unidad }, 
                        success: function (data) {
                            if(data.length > 0){
                                var lista = "";
                                for (i in data) {
                                    lista += '<a id="click-unidad" href="#" data-no="'+data[i].no_unidad+'" data-id="'+data[i].niv+'" class="list-group-item list-group-item-action border-1">'+data[i].niv+'</a>';
                                }
                                $("#show-list").html(lista);
                            } else {
                                $("#show-list").html('<a href="#" class="list-group-item list-group-item-action border-1">No se encontro la unidad</a>');
                            }
                              
                        }});
                    }else{
                        $("#show-list").html('');
                    }
                });
                
                // Al clickear la unidad se obtendran los datos y pintarlos en las tablas
                $(document).on('click','a[id=click-unidad]', function(){
                    $("#buscarUnidad").val('');
                    
                    document.getElementById("no_unidad").innerHTML = $(this).data("no");
                    var niv =  $(this).data("id");
                    $('#niv').val(niv);
                    $("#mostrar-tablas").show();
                    
                    $.ajax({
                        url: 'obtener_unidad_alerta.htm',
                        type: "POST",
                        data: { niv: niv }, 
                    success: function (data) {
                        var tr_unidad = "";
                        var tr_alcancia = "";
                        
                        for(var i in data.alertasUnidad){
                            tr_unidad += '<tr id=""><td class="ancho">'+data.alertasUnidad[i].nombre+'</td><td ><a href="#" data-role="openModalUnidad" data-niv="'+niv+'" data-id="'+data.alertasUnidad[i].id_mensajealerta+'" style="border-color: transparent; background-color: transparent; color: white;">'+data.alertasUnidad[i].cantidad+'</a></td></tr>';
                        }
                        
                        for(var i in data.alertasAlcancia){
                            tr_alcancia += '<tr id=""><td class="ancho">'+data.alertasAlcancia[i].nombre+'</td><td ><a href="#" data-role="openModalAlcancia" data-niv="'+niv+'" data-id="'+data.alertasAlcancia[i].id_mensajealerta+'" style="border-color: transparent; background-color: transparent; color: white;">'+data.alertasAlcancia[i].cantidad+'</a></td></tr>';
                        }
                        
                        var tabla_unidad = '<table id="table-unidad" class="table-alerta" style="width: 100%;"> \n' +
                            '<thead>\n' +
                                '<tr>\n' +
                                    '<th>Unidad</th>\n' +
                                    '<th></th>\n' +
                                '</tr>\n' +
                            '</thead>\n' +
                            '<tbody>\n' +
                                tr_unidad
                            '</tbody>\n' +
                        '</table>';
                
                        var tabla_alcancia = '<table id="table-alcancia" class="table-alerta" style="width: 100%;"> \n' +
                            '<thead>\n' +
                                '<tr>\n' +
                                    '<th>Alcancia</th>\n' +
                                    '<th></th>\n' +
                                '</tr>\n' +
                            '</thead>\n' +
                            '<tbody>\n' +
                                tr_alcancia
                            '</tbody>\n' +
                        '</table>';
                        
                        $('#mostrar-tabla-unidad').html(tabla_unidad);
                        $('#mostrar-tabla-alcancia').html(tabla_alcancia);

                        }});
                
                    $("#show-list").html('');
                });
            });
        </script>
           
        <!-- Obtener las alertas de la unidad -->
        <script>
            $(document).on('click', 'a[data-role=openModalUnidad]', function () {
                
                var id_mensajealerta = $(this).data('id');
                var niv = $(this).data('niv');
                var tr = "";
                
                $.ajax({
                    url: 'obtener_datos_alerta.htm',
                    type: "POST",
                    data: { 
                        niv: niv,
                        id_mensajealerta : id_mensajealerta
                    }, 
                success: function (data) {
                    
                    var tr = "";
                    var contador = 1;
                    
                    if(id_mensajealerta === 1){
                        $("#tablaPuntosControl").dataTable().fnDestroy();
                       
                        for(var i in data.datos){
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].nombre+"</td></tr>";
                            $("#tablaPuntosControl").find('tbody').html(tr);
                            contador++;
                        }
                        paginacion(1);
                        
                        $('#modalPuntosControl').modal('show');
                    }
                    else if(id_mensajealerta === 2){
                        $("#tablaParadasO").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaParadasO").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(2);
                        
                        $('#modaltablaParadasO').modal('show');
                    }
                    else if(id_mensajealerta === 3){
                        $("#tablaITiempo").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].horaI+"</td>"+"<td>"+data.datos[i].horaR+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaITiempo").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(3);
                        
                        $('#modalITiempo').modal('show');
                    }
                    else if(id_mensajealerta === 4){
                        $("#tablaIRecorrido").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ruta+"</td>"+"<td>"+data.datos[i].ramal+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaIRecorrido").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(4);
                        
                        $('#modalIRecorrido').modal('show');
                    }
                    else if(id_mensajealerta === 5){
                        $("#tablaEVelocidad").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].kph+" kph"+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaEVelocidad").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(5);
                        
                        $('#modalEVelocidad').modal('show');
                    }
                    else if(id_mensajealerta === 6){
                        $("#tablaFConexion").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaFConexion").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(6);
                        
                        $('#modalFConexion').modal('show');
                    }
                }});
                 
            });
        </script>
        
        <!-- Obtener las alertas de la unidad por fecha de inicio y fin -->
        <script>
            
            $('#btn-PControl').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioPControl").val();
                var fecha_fin = $("#finPControl").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 1,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaPuntosControl").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioPControl').val(''); 
                    $('#finPControl').val('');
                    
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaPuntosControl").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(1);
                }});
            });
            
            $('#btn-PObligatoria').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioPObligatoria").val();
                var fecha_fin = $("#finPObligatoria").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 2,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaParadasO").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioPObligatoria').val('');
                    $('#finPObligatoria').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaParadasO").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(2);
                }});
            });
            
            $('#btn-Itinerario').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioItinerario").val();
                var fecha_fin = $("#finItinerario").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 3,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaITiempo").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioItinerario').val('');
                    $('#finItinerario').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].horaI+"</td>"+"<td>"+data.datos[i].horaR+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaITiempo").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(3);
                }});
            });
            
            $('#btn-IRecorrido').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioIRecorrido").val();
                var fecha_fin = $("#finIRecorrido").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 4,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaIRecorrido").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioIRecorrido').val('');
                    $('#finIRecorrido').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ruta+"</td>"+"<td>"+data.datos[i].ramal+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaIRecorrido").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(4);
                }});
            });
            
            $('#btn-EVelocidad').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioEVelocidad").val();
                var fecha_fin = $("#finEVelocidad").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 5,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaEVelocidad").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioEVelocidad').val('');
                    $('#finEVelocidad').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].kph+" kph"+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaEVelocidad").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(5);
                }});
            });
            
            $('#btn-FConexion').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioFConexion").val();
                var fecha_fin = $("#finFConexion").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 6,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaFConexion").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioFConexion').val('');
                    $('#finFConexion').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaFConexion").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(6);
                }});
            });
            
        </script>
        
        <!-- Obtener alertas de la alcancia -->
        <script>
            $(document).on('click', 'a[data-role=openModalAlcancia]', function () {
                
                var id_mensajealerta = $(this).data('id');
                var niv = $(this).data('niv');
                var tr = "";
                
                $.ajax({
                    url: 'obtener_datos_alerta.htm',
                    type: "POST",
                    data: { 
                        niv: niv,
                        id_mensajealerta : id_mensajealerta
                    }, 
                success: function (data) {
                    
                    console.log(data);
                    var tr = "";
                    var contador = 1;
                    
                    if(id_mensajealerta === 7){
                        $("#tablaAFConexion").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaAFConexion").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(7);
                        
                        $('#modalAFConexion').modal('show');
                    }
                    else if(id_mensajealerta === 8){
                        $("#tablaAPuerta").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaAPuerta").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(8);
                        
                        $('#modalAPuerta').modal('show');
                    }
                    else if(id_mensajealerta === 9){
                        $("#tablaLNegra").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td>"+"<td>"+data.datos[i].tarjeta+"</td></tr>";
                            $("#tablaLNegra").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(9);
                        
                        $('#modalLNegra').modal('show');
                    }
                    else if(id_mensajealerta === 10){
                        $("#tablaPTermico").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaPTermico").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(10);
                        
                        $('#modalPTermico').modal('show');
                    }
                    else if(id_mensajealerta === 11){
                        $("#tablaPExcesivo").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td>"+"<td>"+data.datos[i].tarjeta+"</td></tr>";
                            $("#tablaPExcesivo").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(11);
                        
                        $('#modalPExcesivo').modal('show');
                    }
                    else if(id_mensajealerta === 12){
                        $("#tablaALlenarse").dataTable().fnDestroy();
                        
                        for(var i in data.datos){
                            
                            tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                            $("#tablaALlenarse").find('tbody').html(tr);
                            contador++;
                        }
                        
                        paginacion(12);
                        
                        $('#modalALlenarse').modal('show');
                    }
                }});
            });
        </script>
        
         <!-- Obtener las alertas de la alcancia por fecha de inicio y fin -->
        <script>
            
            $('#btn-AFConexion').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioAFConexion").val();
                var fecha_fin = $("#finAFConexion").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 7,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaAFConexion").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioAFConexion').val('');
                    $('#finAFConexion').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaAFConexion").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(7);
                }});
            });
            
            $('#btn-APuerta').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioAPuerta").val();
                var fecha_fin = $("#finAPuerta").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 8,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaAPuerta").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioAPuerta').val('');
                    $('#finAPuerta').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaAPuerta").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(8);
                }});
            });
            
            $('#btn-LNegra').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioLNegra").val();
                var fecha_fin = $("#finLNegra").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 9,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaLNegra").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioLNegra').val('');
                    $('#finLNegra').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td>"+"<td>"+data.datos[i].tarjeta+"</td></tr>";
                        $("#tablaLNegra").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(9);
                }});
            });
            
            $('#btn-PTermico').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioPTermico").val();
                var fecha_fin = $("#finPTermico").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 10,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaPTermico").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioPTermico').val('');
                    $('#finPTermico').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaPTermico").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(10);
                }});
            });
            
            $('#btn-PExcesivo').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioPExcesivo").val();
                var fecha_fin = $("#finPExcesivo").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 11,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    
                    $("#tablaPExcesivo").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioPExcesivo').val('');
                    $('#finPExcesivo').val('');
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td>"+"<td>"+data.datos[i].tarjeta+"</td></tr>";
                        $("#tablaPExcesivo").find('tbody').html(tr);
                        contador++;
                    }
                    
                    paginacion(11);
                }});
            });
            
            $('#btn-ALlenarse').click(function (e) {
                e.preventDefault();
                
                var fecha_inicio = $("#inicioALlenarse").val();
                var fecha_fin = $("#finALlenarse").val(); 
                var niv = $("#niv").val(); 
                
                $.ajax({
                url: 'obtener_datos_alerta_fecha.htm',
                type: "POST",
                data:{
                    niv: niv,
                    id_mensajealerta: 12,
                    fecha_inicio: fecha_inicio,
                    fecha_fin: fecha_fin
                },
                success: function (data) {
                    $("#tablaALlenarse").dataTable().fnDestroy();
                    
                    var tr = "";
                    var contador = 1;
                    $('#inicioALlenarse').val('');
                    $('#finALlenarse').val('');
                    
                    for(var i in data.datos){
                            
                        tr += "<tr><td>"+contador+"</td>"+"<td>"+data.datos[i].hora+"</td>"+"<td>"+data.datos[i].fecha+"</td>"+"<td>"+data.datos[i].ubicacion+"</td></tr>";
                        $("#tablaALlenarse").find('tbody').html(tr);
                        contador++;
                    }
                    paginacion(12);
                }});
            });
            
        </script>
        
        <!-- Tablas -->
        <script>
            
            function paginacion(id){
                if(id === 1){
                    $('#tablaPuntosControl').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 2){
                    $('#tablaParadasO').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 3){
                    $('#tablaITiempo').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 4){
                    $('#tablaIRecorrido').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 5){
                    $('#tablaEVelocidad').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 6){
                    $('#tablaFConexion').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 7){
                    $('#tablaAFConexion').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 8){
                    $('#tablaAPuerta').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 9){
                    $('#tablaLNegra').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 10){
                    $('#tablaPTermico').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 11){
                    $('#tablaPExcesivo').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                else if(id === 12){
                    $('#tablaALlenarse').DataTable( {
                        "ordering": false,
                        "info":     false,
                        "searching": false,
                        "lengthChange": false,
                        "paging": true,
                        "lengthMenu": [ 5, 10, 20, 30, 50 ],
                        "pagingType": "numbers",
                        "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                    });
                }
                
            }
        </script>
        
        <!-- Datepicker -->
        <script>
            $('#inicioPControl,#finPControl,\n\
               #inicioPObligatoria,#finPObligatoria,\n\
               #inicioItinerario,#finItinerario,\n\
               #inicioIRecorrido,#finIRecorrido,\n\
               #inicioEVelocidad,#finEVelocidad,\n\
               #inicioFConexion,#finFConexion,\n\
               #inicioAFConexion,#finAFConexion,\n\
               #inicioAPuerta,#finAPuerta,\n\
               #inicioLNegra,#finLNegra,\n\
               #inicioPTermico,#finPTermico,\n\
               #inicioPExcesivo,#finPExcesivo,\n\
               #inicioALlenarse,#finALlenarse').datepicker({
                autoclose: true,
                format: "yyyy-mm-dd",
                language: "es"
            });
        </script>
        
    </body>

</html>
