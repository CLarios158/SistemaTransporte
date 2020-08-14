<%@page import="java.util.Iterator"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="Model.lectura_vehiculo"%>
<%@page import="java.util.List"%>
<%@page import="ModelDAO.lectura_vehiculoDAO"%>
<%@page import="Config.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <title>Sistema de Monitoreo</title>
        <script defer
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAdTfw1waJScSYaMdXKGqAW6rnHcwmjZwc&callback=initMap">
        </script>

        <!--link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"/-->
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
        <link rel="stylesheet" href="css/bootstrap.min.css">
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
                        <div class="cn-wrapper">
                        </div>
                    </div>     
                                
                    <div class="col-md-5">
                        <div class="cn-wrapper">
                        </div>
                    </div>


                </div>
            </div>
        </nav>

        <main>
            <div style="width:  30%;" class="slide-menu main-slide-menu show" id="main-slide-menu">
                <!--<a class="btn-slide-menu d-flex flex-no-wrap align-items-center" href="" data-toggle="slide-menu"
                   data-target="#main-slide-menu">
                    <i class="icon"></i>
                </a>-->
                <nav class="nav nav-horizontal flex-row">
                    <a class="color-label" href="<c:url value="index.htm" />"><i class="fas fa-home color-icon"></i>Ramal |</a>
                    <a class="color-label-bold" href="<c:url value="consultar_ruta.htm" />" >Consultar Ramal</a>
                </nav>
                <div class="card main-slide-menu-card">
                    <div class="card-body">
                        <div id="buscar-ramal" class=" row">
                            <label class="col-sm-12" for="Buscar">Buscar ramal:</label>
                            <div class="col-sm-12 input-icons">
                                <i class="fas fa-search icon-input"></i>
                                <input type="text" class="form-control" name="buscarRamal" id="buscarRamal" autocomplete="off">
                                <div style="z-index: 2; position: absolute; width: 90%;" class="list-group" id="show-list"></div>
                            </div>
                        </div>
                        <div id="editar-ramal" style="display: none;">
                            <input id="id_ramal" name="id_ramal" hidden />
                            <input id="ramal-seleccionada" name="ramal-seleccionada" hidden />
                            <div class="form-group row ">
                                <label for="nombre" class="col-sm-4 col-form-label">Nombre:</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" name="nombre" id="nombre" autocomplete="off">
                                </div>
                            </div>
                            <div class="form-group row ">
                                <label for="numero" class="col-sm-4 col-form-label">Número:</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" name="numero" id="numero" autocomplete="off">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="ruta" class="col-sm-4 col-form-label">Ruta asignada:</label>
                                <div class="col-sm-8">
                                    <select class="form-control" id="selectRuta" name="selectRuta">
                                        <option value="empty"></option>
                                        <%
                                            try {
                                                ResultSet r = Conexion.query("SELECT id_ruta, nombre FROM cat_ruta;");
                                                while (r.next()) {%>
                                                    <option value=<%= r.getString(1)%>><%= r.getString(2)%></option>
                                        <%}
                                                r.close();
                                            } catch (Exception e) {
                                            }
                                        %>
                                    </select>
                                </div>                            
                            </div>
                            <div class="form-group row">
                                <label for="unidad" class="col-sm-4 col-form-label">Buscar unidad:</label>
                                <div class="col-sm-8 input-icons">
                                    <i class="fas fa-search icon-input"></i>
                                    <input type="text" class="form-control" name="buscarUnidad" id="buscarUnidad" autocomplete="off">
                                    <div style="z-index: 2; position: absolute; width: 90%;" class="list-group" id="show-list-unidades"></div>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="unidad" class="col-sm-4 col-form-label">Unidades Asignadas:</label>
                                <div class="col-sm-8">
                                    <div  id="unidades"></div>
                                </div>
                            </div>
                            <input hidden type="text" id="kmz" name="kmz">
                            <input hidden type="text" id="unidadesA" name="unidadesA" />
                        </div>
                    </div>
                    <div class="card-footer"> 
                        <div id="opciones-ramal" style="display: none;">
                            <div class="row card-actions">
                                <div class="col center"><button id="btn-editar" style="margin-right: 0;"><i class="fas fa-edit"></i></button></div>
                                <div class="col center"><button id="modalDeshabilitar"  style="margin-right: 0;"><i class="fas fa-ban"></i></button></div>
                                <div class="col center"><button id="modalEliminar" style="margin-right: 0;"><i class="fas fa-trash"></i></button></div>
                            </div> 
                            <div  class="row"> 
                                <div class="col center"><label for="editar">Editar</label></div>
                                <div class="col center"><label for="deshabilitar">Deshabilitar</label></div>
                                <div class="col center"><label for="elimnar">Eliminar</label></div>
                            </div>
                        </div>
                        <div id="guardar-ramal" class="center" style="display: none;">
                            <button id="btn-cancelar" class="btn btn-outline-primary">Cancelar</button>
                            <button id="btn-guardar" type="submit" class="btn btn-primary btn-small">Guardar</button>
                        </div>
                    </div>
                </div>
            </div>

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

            <!-- map-container -->
            <div class="map-container" id="map" style="z-index: 1"></div>
            <div id="paleta-colores" style="position: absolute; top: 5px; left: 31%; z-index: 5; display: none;">
                <div class="row">
                    <div class="col center">
                        <button class="btn btn-primary"><i style="font-size: 15px;" class="fas fa-eye-dropper"></i></button>
                    </div> 
                </div>
                <div class="color-popup">
                    <div class="row">
                        <div  class="column"><button id="color-1" value="#ffff00" style="background-color: #ffff00;" class="btn-color"></button></div>
                        <div  class="column"><button id="color-2" value="#ff0000" style="background-color: #ff0000;" class="btn-color"></button></div>
                        <div  class="column"><button id="color-3" value="#ffffff" style="background-color: #ffffff;" class="btn-color"></button></div>

                    </div> 
                    <div class="row">
                        <div  class="column"><button id="color-4" value="#ff8000" style="background-color: #ff8000;" class="btn-color"></button></div>
                        <div  class="column"><button id="color-5" value="#800080" style="background-color: #800080;" class="btn-color"></button></div>
                        <div  class="column"><button id="color-6" value="#adff2f" style="background-color: #adff2f;" class="btn-color"></button></div>
                    </div> 
                </div>
            </div>
            <!--<div id="btn-deshacer" style="position: absolute; top: 92%; left: 30%; z-index: 5;">
                <div class="row">
                    <div class="col center">
                        <button class="btn btn-primary" id="delete"><i style="font-size: 15px;" class="fas fa-undo"></i> Deshacer</button>
                    </div>
                </div>
            </div>-->
            <div id="borrar-ruta" style="position: absolute; top: 92%; left: 30%; z-index: 5; display: none;">
                <div class="row">
                    <div class="col center">
                        <button class="btn btn-primary" id="delete"><i style="font-size: 15px;" class="fas fa-trash"></i> Borrar</button>
                    </div>
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
        
        <!-- Modal Deshabilitar Ramal-->
        <div class="modal fade" id="deshabilitarRamal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col center"><i style="color: #c82333;" class="fas fa-exclamation-circle fa-2x"></i></div>
                        </div>
                        <div class="row">
                            <div class="col center"><h6 class="text-white">Deshabilitar Ramal</h6></div>
                        </div>
                        <div class="separator center"></div>
                        <div class="row">
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 12px;">¿Desea deshabilitar el ramal </p><p style="color: #f8e71c; font-weight: bold; font-size: 12px;" id="ramalSeleccionada"></p></div>
                        </div>
                        <div class="row">
                            <div class="col text-right"><button class="btn btn-primary" data-dismiss="modal"><i class="fas fa-times"></i>Cancelar</button></div>
                            <div class="col"><button id="btn-deshabilitar" class="btn btn-outline-primary" data-dismiss="modal"><i class="fas fa-trash"></i>Aceptar</button></div>  
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Eliminar Ramal-->
        <div class="modal fade" id="eliminarRamal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col center"><i style="color: #c82333;" class="fas fa-exclamation-triangle fa-2x"></i></div>
                        </div>
                        <div class="row">
                            <div class="col center"><h6 class="text-white">Eliminar</h6></div>
                        </div>
                        <div class="separator center"></div>
                        <div class="row">
                            <div class="col center"><p style="font-size: 12px;">Si elimina este ramal se eliminará la información que esta contiene junto con sus elementos asociados</p></div>
                        </div>
                        <div class="row">
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 12px;">¿Desea eliminar el ramal</p><p style="color: #f8e71c; font-weight: bold; font-size: 12px;" id="ramalSeleccionada2"></p></div>
                        </div>
                        <div class="row">
                            <div class="col text-right"><button class="btn btn-primary" data-dismiss="modal"><i class="fas fa-times"></i>Cancelar</button></div>
                            <div class="col"><button id="btn-eliminar" class="btn btn-outline-primary" data-dismiss="modal"><i class="fas fa-trash"></i>Aceptar</button></div>  
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal de Exito-->
        <div class="modal fade" id="modalExito" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col center"><i style="color: #28a745;" class="fas fa-check-circle fa-2x"></i></div>
                        </div>
                        <div class="row">
                            <div class="col center"><h4 class="text-white">Exito</h4></div>
                        </div>
                        <div class="separator center"></div>
                        <div class="row">
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 12px;" id="msgExito"></p></div>
                        </div>
                        <div class="row">
                            <div class="col center"><button class="btn btn-primary" data-dismiss="modal">Aceptar</button></div> 
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script
            src="https://code.jquery.com/jquery-3.4.1.js"
            integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
        crossorigin="anonymous"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>


        <script type="text/javascript">
            
            var coords;
            
            coordinates({lat: 19.243772, lng: -103.714532});
            
            function coordinates(x){
                coords = x;
            } 
            
             //Mostrar mapa
            function initMap(){
                var map = new google.maps.Map(document.getElementById('map'), {
                    zoom: 13,
                    center: coords,
                    styles: [
                        {elementType: 'geometry', stylers: [{color: '#03060c'}]},
                        {elementType: 'labels.text.stroke', stylers: [{color: '#0A1E28'}]},
                        {elementType: 'labels.text.fill', stylers: [{color: '#746855'}]},
                        {
                            featureType: 'administrative.locality',
                            elementType: 'labels.text.fill',
                            stylers: [{color: '#83888d'}]
                        },
                        {
                            featureType: 'poi',
                            elementType: 'labels.text.fill',
                            stylers: [{color: '#83888d'}]
                        },
                        {
                            featureType: 'poi.park',
                            elementType: 'geometry',
                            stylers: [{color: '#263c3f'}]
                        },
                        {
                            featureType: 'poi.park',
                            elementType: 'labels.text.fill',
                            stylers: [{color: '#6b9a76'}]
                        },
                        {
                            featureType: 'road',
                            elementType: 'geometry',
                            stylers: [{color: '#0e1c23'}]
                        },
                        {
                            featureType: 'road',
                            elementType: 'geometry.stroke',
                            stylers: [{color: '#212a37'}]
                        },
                        {
                            featureType: 'road',
                            elementType: 'labels.text.fill',
                            stylers: [{color: '#9ca5b3'}]
                        },
                        {
                            featureType: 'road.highway',
                            elementType: 'geometry',
                            stylers: [{color: '#009186'}]
                        },
                        {
                            featureType: 'road.highway',
                            elementType: 'geometry.stroke',
                            stylers: [{color: '#1f2835'}]
                        },
                        {
                            featureType: 'road.highway',
                            elementType: 'labels.text.fill',
                            stylers: [{color: '#f3d19c'}]
                        },
                        {
                            featureType: 'transit',
                            elementType: 'geometry',
                            stylers: [{color: '#830203'}]
                        },
                        {
                            featureType: 'transit.station',
                            elementType: 'labels.text.fill',
                            stylers: [{color: '#d59563'}]
                        },
                        {
                            featureType: 'water',
                            elementType: 'geometry',
                            stylers: [{color: '#17263c'}]
                        },
                        {
                            featureType: 'water',
                            elementType: 'labels.text.fill',
                            stylers: [{color: '#515c6d'}]
                        },
                        {
                            featureType: 'water',
                            elementType: 'labels.text.stroke',
                            stylers: [{color: '#17263c'}]
                        }
                    ]
                });
                
                map.addListener('click', addLatLng);
                
                //Añadir un punto al mapa
                function addLatLng(event) {
                    var kmz = $("#kmz").val();
                    var json = JSON.parse(kmz);
                    var arrayKMZ = [];
                    
                    for(var i in json){
                        arrayKMZ.push(json[i]);
                    }
                    
                    arrayKMZ.push({lng: event.latLng.lng(), lat: event.latLng.lat()});
                    $("#kmz").val(JSON.stringify(arrayKMZ));
                    
                    var poly = Polyline(arrayKMZ);
                    poly.setMap(map);
                    var markers = Marker(arrayKMZ, map);
                }
                
                return map;
            }
           
            //Crear la linea entro los puntos
            function Polyline(path){
                var poly = new google.maps.Polyline({
                    path: path,
                    strokeColor: '#FF0000',
                    strokeOpacity: 5,
                    strokeWeight: 3
                });
                
                $("#color-1").click(function () {
                    var color = $(this).val();
                    poly.setOptions({strokeColor: color, fillColor: color, fillOpacity: 0.35});
                });

                $("#color-2").click(function () {
                    var color = $(this).val();
                    poly.setOptions({strokeColor: color, fillColor: color, fillOpacity: 0.35});
                });

                $("#color-3").click(function () {
                    var color = $(this).val();
                    poly.setOptions({strokeColor: color, fillColor: color, fillOpacity: 0.35});
                });

                $("#color-4").click(function () {
                    var color = $(this).val();
                    poly.setOptions({strokeColor: color, fillColor: color, fillOpacity: 0.35});
                });

                $("#color-5").click(function () {
                    var color = $(this).val();
                    poly.setOptions({strokeColor: color, fillColor: color, fillOpacity: 0.35});
                });

                $("#color-6").click(function () {
                    var color = $(this).val();
                    poly.setOptions({strokeColor: color, fillColor: color, fillOpacity: 0.35});
                });
                
                return poly;
            }
            
            //Crear y Editar los puntos 
            function Marker(markers, map){
                var array = [];
                var latG;
                var lngG;
                
                for (var i = 0; i < markers.length; i++) {  
                    var marker = new google.maps.Marker({
                        position: markers[i],
                        map: map,
                        draggable: true
                    });
                    
                    array.push(marker);
                    
                    google.maps.event.addListener(array[i], "mousedown", function(event) {
                        latG = event.latLng.lat();
                        lngG = event.latLng.lng();
                    });
                    
                    (function (i) {
                        google.maps.event.addListener(array[i], 'dragend', function (m) {
                            var lat = m.latLng.lat();
                            var lng = m.latLng.lng();
                            //console.log(lat);
                            //console.log(lng);
                           
                            var kmz = $("#kmz").val();
                            var json = JSON.parse(kmz);
                            var arrayKMZ = [];
                            
                            json.find(item=>item.lat === latG).lat = lat;
                            json.find(item=>item.lng === lngG).lng = lng;
                           
                            for(var i in json){
                                arrayKMZ.push(json[i]);
                            }
                            
                            $("#kmz").val(JSON.stringify(arrayKMZ));
                            var coords = coordinates(arrayKMZ[0]);
                            var map = initMap();
                            var poly = Polyline(arrayKMZ);
                            poly.setMap(map);
                            var markers = Marker(arrayKMZ, map);
                        });
                    })(i);  
                }
                
                return array;
            }
            
        </script>
        
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
        
        <!--Buscar Ramal -->
        <script type="text/javascript">
            $(document).ready(function () {
                $("#buscarRamal").keyup(function(e){
                    e.preventDefault();
                   
                   var ramal = $(this).val();
                   if(ramal !== ''){
                       $.ajax({
                            url: 'buscar_ramal.htm',
                            type: "GET",
                            data: { ramal: ramal }, 
                        success: function (data) {
                            if(data.length > 0){
                                var lista = "";
                                for (i in data) {
                                    lista += '<a id="click-ramal" href="#" data-value="'+data[i].nombre+'" data-id="'+data[i].id_ramal+'" class="list-group-item list-group-item-action border-1">'+data[i].nombre+'</a>';
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
                
                $(document).on('click','a[id=click-ramal]', function(e){
                    
                    $("#opciones-ramal").show();
                    
                    $("#buscarRamal").val($(this).text());
                    var id_ramal = $(this).data("id");
                    var ramal_seleccionada = $(this).data('value');
                    $("#id_ramal").val(id_ramal);
                    $("#ramal-seleccionada").val(ramal_seleccionada);
                    
                    $("#show-list").html('');
                    
                });
                
                
            });
        </script>
        
        <!-- Funcionalidad de los botones -->
        <script type = "text/javascript">
            
            $('#btn-cancelar').click(function () {
                location.reload();
            });
            
            $('#modalDeshabilitar').click(function () {
                document.getElementById("ramalSeleccionada").innerHTML = "&nbsp"+$("#ramal-seleccionada").val()+"?"; 
                $('#deshabilitarRamal').modal('show');
            });
            
            $('#modalEliminar').click(function () {
                document.getElementById("ramalSeleccionada2").innerHTML = "&nbsp"+$("#ramal-seleccionada").val()+"?"; 
                $('#eliminarRamal').modal('show');
            });
            
        </script>
        
        <!--Buscar Unidad -->
        <script type="text/javascript">
            $(document).ready(function () {
                $("#buscarUnidad").keyup(function(e){
                    e.preventDefault();
                   
                   var unidad = $(this).val();
                   if(unidad !== ''){
                       $.ajax({
                            url: 'buscar_unidad.htm',
                            type: "GET",
                            data: { unidad: unidad }, 
                        success: function (data) {
                            if(data.length > 0){
                                var lista = "";
                                for (i in data) {
                                    lista += '<a id="click-unidad" href="#" data-id="'+data[i].id_unidad+'" class="list-group-item list-group-item-action border-1">'+data[i].no_unidad+'</a>';
                                }
                                $("#show-list-unidades").html(lista);
                            } else {
                                $("#show-list-unidades").html('<a href="#" class="list-group-item list-group-item-action border-1">No se encontro la unidad</a>');
                            }
                              
                        }});
                    }else{
                        $("#show-list-unidades").html('');
                    }
                });
                
                let array = [];
                
                $(document).on('click','a[id=click-unidad]', function(){
                    $("#buscarUnidad").val('');
                    var id =  $(this).data("id");
                    console.log($("#unidadesA").val());
                    var button = '<button id="eliminarUnidad" class="btn btn-unidades">Unidad '+$(this).text()+'</button>';
                    $("#unidades").append(button);
                    $("#show-list-unidades").html('');
                });
            });
        </script>
        
        <!-- Editar Ramal -->
        <script type = "text/javascript">
            
            $('#btn-editar').click(function (e) {
                
                e.preventDefault();
                
                $("#buscar-ramal").hide();
                $("#opciones-ramal").hide();
                $("#paleta-colores").show();
                $("#borrar-ruta").show();
                
                var id_ramal = $("#id_ramal").val();
                
                $.ajax({
                        url: 'obtener_datos_ramal.htm',
                        type: "POST",
                        dataType: 'json',
                        data: {id_ramal: id_ramal},
                        success: function (data) {
                            $("#editar-ramal").show();
                            $("#guardar-ramal").show();
                            
                            $("#id_ramal").val(data.id_ramal);
                            $("#nombre").val(data.nombre);
                            $("#numero").val(data.numero);
                            document.getElementById("selectRuta").value = data.id_ruta;
                            $("#kmz").val(JSON.stringify(data.kmz));
                            $("#unidadesA").val(JSON.stringify(data.unidades));
                            
                            for(var i in data.unidades){
                                var button = '<button type="button" id="btn-eliminar-unidad" class="btn btn-unidades">Unidad '+data.unidades[i].no_unidad+'</button>';
                                $("#unidades").append(button);
                            }
                            
                            var kmz = JSON.parse($("#kmz").val());
                            var arrayKMZ = [];

                            for(var i in kmz){
                                arrayKMZ.push(kmz[i]);
                            }

                            var coords = coordinates(arrayKMZ[0]);
                            var map = initMap();
                            var poly = Polyline(arrayKMZ);
                            poly.setMap(map);
                            var markers = Marker(arrayKMZ, map);
                              
                        }, error: function (error) {
                            console.log(error);
                        }
                    });
            });

        </script>
        
        <!-- Deshabilitar Ramal -->
        <script type = "text/javascript">
            
            $('#btn-deshabilitar').click(function (e) {
                e.preventDefault();
                var buscarRamal = $("#buscarRamal").val();
                
                if(buscarRamal !== ''){
                    var id_ramal = $("#id_ramal").val();
                    var currentDate = new Date();
                    var fecha_actualizacion = currentDate.getFullYear() + "-" + (('0' + (currentDate.getMonth() + 1)).slice(-2)) + "-" + ('0' + currentDate.getDate()).slice(-2) + " " + ("0" + currentDate.getHours()).slice(-2) + ":" + ("0" + currentDate.getMinutes()).substr(-2) + ":" + currentDate.getSeconds();        

                    $.ajax({
                        url: 'deshabilitar_ramal.htm',
                        type: "POST",
                        dataType: 'json',
                        data: {
                            id_ramal: id_ramal,
                            statusRamal: 0,
                            fecha_actualizacion: fecha_actualizacion
                        },
                        success: function (data) {
                            var nombre = data.nombre;
                            document.getElementById("msgExito").innerHTML = "Se ha deshabilitado el ramal"+"&nbsp"+nombre; 
                            $('#modalExito').modal('show');
                            $('#modalExito').on('hidden.bs.modal', function () {
                                location.reload();
                            });
                        }
                    });
                }
            });
        </script>
        
        <!-- Eliminar Ramal -->
        <script type = "text/javascript">
            
            $('#btn-eliminar').click(function (e) {
                e.preventDefault();
                
                var buscarRamal = $("#buscarRamal").val();
                
                if(buscarRamal !== ''){
                    var id_ramal = $("#id_ramal").val();

                    $.ajax({
                        url: 'eliminar_ramal.htm',
                        type: "POST",
                        dataType: 'json',
                        data: {
                            id_ramal: id_ramal
                        },
                        success: function (data) {
                            document.getElementById("msgExito").innerHTML = "Se ha eliminado el ramal correctamente"; 
                            $('#modalExito').modal('show');
                            $('#modalExito').on('hidden.bs.modal', function () {
                                location.reload();
                            });
                        },
                        error: function (error) {
                            console.log(error);
                        }
                    });
                }
            });
        </script>
      
        <!-- Actualizar los datos del ramal -->
        <script type = "text/javascript">
            
            $('#btn-guardar').click(function (e) {
                e.preventDefault();
                
                var id_ramal = $("#id_ramal").val();
                var nombre = $("#nombre").val();
                var numero = $("#numero").val();
                var id_ruta = $("#selectRuta").val();
                var kmz = $("#kmz").val();
                var currentDate = new Date();
                var fecha_actualizacion = currentDate.getFullYear() + "-" + (('0' + (currentDate.getMonth() + 1)).slice(-2)) + "-" + ('0' + currentDate.getDate()).slice(-2) + " " + ("0" + currentDate.getHours()).slice(-2) + ":" + ("0" + currentDate.getMinutes()).substr(-2) + ":" + currentDate.getSeconds();
               
                $.ajax({
                    url: 'editar_ramal.htm',
                    type: "POST",
                    dataType: 'json',
                    data: {
                        id_ramal: id_ramal,
                        nombre: nombre,
                        numero: numero,
                        kmz: kmz,
                        id_ruta: id_ruta,
                        fecha_actualizacion: fecha_actualizacion
                    },
                    success: function (data) {
                        var nombre = data.nombre;
                        document.getElementById("msgExito").innerHTML = "Se ha actualizado los datos del ramal"+"&nbsp"+nombre; 
                        $('#modalExito').modal('show');
                        $('#modalExito').on('hidden.bs.modal', function () {
                            location.reload();
                        });
                    },
                    error: function (error) {
                        console.log(error);
                    }
                });
            });
        </script>
    </body>

</html>

