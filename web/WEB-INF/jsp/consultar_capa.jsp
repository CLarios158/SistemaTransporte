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
                    </div>      


                    <div class="col-md-5">
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
                <div id="show-capa">
                    <nav class="nav nav-horizontal flex-row">
                        <a class="color-label" href="<c:url value="index.htm" />"><i class="fas fa-home color-icon"></i>Capas |</a>
                        <a class="color-label-bold" href="<c:url value="crear_capa.htm" />" >Consultar Capa</a>
                    </nav>
                    <div class="card main-slide-menu-card">
                        <div class="card-body">
                                <div id="mostrar-capa">
                                    <div class="form-group"><h5 class="center text-white">CAPAS</h5></div>
                                    <div id="capas" class="form-group row"></div>
                                </div>
                                <div id="editar-capa" style="display: none;">
                                    <input id="id_capa" name="id_capa" hidden />
                                    <input id="capa-seleccionada" name="estatus" hidden />
                                    <input id="estatus" name="capa-seleccionada" hidden />
                                    <div class="form-group row ">
                                        <label for="nombre" class="col-sm-4 col-form-label">Nombre:</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" name="nombre" id="nombre" autocomplete="off" onkeyup="validarCapa(this);">
                                            <p id="errorCapa" style="color: #F8E71C; font-size: 12px; height: 0px;"></p>
                                        </div>
                                    </div>
                                    <div class="form-group row ">
                                        <label for="numero" class="col-sm-4 col-form-label">Adjuntar icono:</label>
                                        <div class="col-sm-4">
                                            <div class="upload-img" id="previewImg2"></div>
                                            <input id="rutaFoto" name="rutaFoto" hidden>
                                            <input type="file" id="file" name="file">
                                            <label class="btn-file" for="file">Cargar</label>
                                        </div>
                                    </div>
                                    <input hidden type="text" id="kmz" name="kmz">
                                </div>
                        </div>
                        <div class="card-footer" >
                            <div id="opciones-capa" style="display: none;">
                                <div class="row card-actions">
                                    <div class="col center"><button type="text" id="btn-editar" style="margin-right: 0;"><i class="fas fa-edit"></i></button></div>
                                    <div class="col center"><button type="text" id="modalDeshabilitar"  style="margin-right: 0;"><i class="fas fa-ban"></i></button></div>
                                    <div class="col center"><button type="text" id="modalEliminar" style="margin-right: 0;"><i class="fas fa-trash"></i></button></div>
                                </div> 
                                <div  class="row">
                                    <div class="col center"><label for="editar">Editar</label></div>
                                    <div class="col center"><label id="nombre-status" for="deshabilitar"></label></div>
                                    <div class="col center"><label for="elimnar">Eliminar</label></div>
                                </div>
                            </div>
                            <div id="guardar-capa" class="center" style="display: none;">
                                <button class="btn btn-outline-primary">Cancelar</button>
                                <button id="btn-guardar" type="submit" class="btn btn-primary btn-small">Guardar</button>
                            </div>
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
            <!--<div id="btn-deshacer" style="position: absolute; top: 92%; left: 30%; z-index: 5; display: none;">
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

        <!-- Modal Deshabilitar Capa-->
        <div class="modal fade" id="deshabilitarCapa" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col center"><i style="color: #c82333;" class="fas fa-exclamation-circle fa-2x"></i></div>
                        </div>
                        <div class="row">
                            <div class="col center"><h5 class="text-white" id="title"></h5></div>
                        </div>
                        <div class="separator center"></div>
                        <div class="row">
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 14px;" id="capaSeleccionada"></p></div>
                        </div>
                        <div class="row">
                            <div class="col text-right"><button class="btn btn-primary" data-dismiss="modal"><i class="fas fa-times"></i>Cancelar</button></div>
                            <div class="col"><button id="btn-deshabilitar" class="btn btn-outline-primary" data-dismiss="modal"><i class="fas fa-trash"></i>Aceptar</button></div>  
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Eliminar Capa-->
        <div class="modal fade" id="eliminarCapa" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col center"><i style="color: #c82333;" class="fas fa-exclamation-triangle fa-2x"></i></div>
                        </div>
                        <div class="row">
                            <div class="col center"><h5 class="text-white">Eliminar</h5></div>
                        </div>
                        <div class="separator center"></div>
                        <div class="row">
                            <div class="col center"><p style="font-size: 14px;">Si elimina esta capa se eliminará la información que esta contiene junto con sus elementos asociados</p></div>
                        </div>
                        <div class="row">
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 14px;">¿Desea eliminar la capa</p><p style="color: #f8e71c; font-weight: bold; font-size: 14px;" id="capaSeleccionada2"></p></div>
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
                            <div class="col center"><h5 class="text-white">Exito</h5></div>
                        </div>
                        <div class="separator center"></div>
                        <div class="row">
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 14px;" id="msgExito"></p></div>
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
            
            function initMap(coordenadas){
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
                
                return map;
            }
            
            function Polygon(path){
                var poly = new google.maps.Polygon({
                    paths: path,
                    strokeColor: "#FF0000",
                    strokeOpacity: 0.8,
                    strokeWeight: 3,
                    fillColor: "#FF0000",
                    fillOpacity: 0.35
                });
                
                
                return poly;
            }
            
            function Marker(markers, map){
                console.log(markers);
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
                            var map = initMap(arrayKMZ[0]);
                            var poly = Polygon(arrayKMZ);
                            poly.setMap(map);
                            var markers = Marker(arrayKMZ, map);
                        });
                    })(i);  
                }
                
                return array;
            }
            
            function deleteMarker(marker, markers){
                for (i = 0; i < markers.length; i++) { 
                    if(markers[i].lat === marker.getPosition().lat()){
                        marker.setMap(null);
                    }
                    
                }
            }
            
        </script>
        
        <script type = "text/javascript">
            
            $('#cancelar').click(function () {
                $("#show-capa").show();
                $("#edit-capa").hide();
            });
            
            $('#modalDeshabilitar').click(function () {
                var estatus = $("#estatus").val();
                if(estatus === '1'){
                    document.getElementById("title").innerHTML = "Deshabilitar Capa";
                    document.getElementById("capaSeleccionada").innerHTML = "¿Desea deshabilitar la capa"+"&nbsp"+$("#capa-seleccionada").val()+"?"; 
                } else{
                    document.getElementById("title").innerHTML = "Habilitar Capa";
                    document.getElementById("capaSeleccionada").innerHTML = "¿Desea habilitar la capa"+"&nbsp"+$("#capa-seleccionada").val()+"?"; 
                }
                $('#deshabilitarCapa').modal('show');
            });
            
            $('#modalEliminar').click(function () {
                document.getElementById("capaSeleccionada2").innerHTML = "&nbsp"+$("#capa-seleccionada").val()+"?"; 
                $('#eliminarCapa').modal('show');
            });

        </script>
        

        <!-- Obtener capas -->
        <script type="text/javascript">
            $(document).ready(function () {
                var capas = "";
                <c:forEach var="capa" items="${capas}">
                    capas += '\
                        <div id="seleccionado" class="col-sm-3" style="height: 50px; margin-bottom: 10px;">\n\
                            <div  class="center" >\n\
                                <div>\n\
                                    <a id="click-capa" data-status="${capa.getEstatus()}" data-value="${capa.getNombre()}" data-id="${capa.getId()}" href="#"><img style="width: 20px; height: 20px; margin: 6px;" src="${capa.getIcon()}"/></a>\n\
                                </div>\n\
                            </div>\n\
                            <div class="center"><p style="font-size: 12px; text-align: center;">${capa.getNombre()}</p></div>\n\
                        </div>';
                </c:forEach>

                $("#capas").append(capas);

                $(document).on('click', 'a[id=click-capa]', function (e) {
                    e.preventDefault();
                    
                    var id_capa = $(this).data("id");
                    var capa_seleccionada = $(this).data('value');
                    var status = $(this).data('status');
                    
                    if(status === 1){
                        document.getElementById("nombre-status").innerHTML = "Deshabilitar";
                    } else{
                        document.getElementById("nombre-status").innerHTML = "Habilitar";
                    }
                    
                    $("#id_capa").val(id_capa);
                    $("#capa-seleccionada").val(capa_seleccionada);
                    $("#estatus").val(status);
                    
                    $("#opciones-capa").show();

                });
            });
        </script>
        
        <!-- Previsualizar el icono -->
        <script type="text/javascript">
            $(document).ready(function () {
                function filePreview(input) {
                    if (input.files && input.files[0]) {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            $('#previewImg2').html("<img style='width: 20px; height: 20px; margin: 6px;' src='" + e.target.result + "' />");
                        };
                        reader.readAsDataURL(input.files[0]);
                    }
                }

                $('#file').change(function () {
                    filePreview(this);
                });
            });

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
        
        <!-- Eliminar el area del mapa -->
        <script>
            $("#borrar-ruta").click(function () {
                document.getElementById("kmz").value = "";
                
                var map = initMap();
                var kmz = [];
                var poly;
                
                poly = new google.maps.Polygon({
                    strokeColor: '#FF0000',
                    strokeOpacity: 0.8,
                    strokeWeight: 3,
                    fillColor: '#FF0000',
                    fillOpacity: 0.35
                });

                poly.setMap(map);
                
                // Add a listener for the click event
                map.addListener('click', addLatLng);

                // Handles click events on a map, and adds a new point to the Polyline.
                function addLatLng(event) {
                    var path = poly.getPath();
                    // Because path is an MVCArray, we can simply append a new coordinate
                    // and it will automatically appear.
                    path.push(event.latLng);
                    kmz.push({lat: event.latLng.lat(), lng: event.latLng.lng()});
                    kmzJSON = JSON.stringify(kmz);
                    document.getElementById("kmz").value = kmzJSON;
                    
                    // Add a new marker at the new plotted point on the polyline.
                    var marker = new google.maps.Marker({
                        position: event.latLng,
                        title: '#' + path.getLength(),
                        map: map,
                        draggable: true
                    });
                    
                    google.maps.event.addListener(marker, "mousedown", function(event) {
                        latG = event.latLng.lat();
                        lngG = event.latLng.lng();
                        console.log(latG);
                    });
                    
                    google.maps.event.addListener(marker, 'dragend', function (m) {
                        var lat = m.latLng.lat();
                        var lng = m.latLng.lng();

                        kmz.find(item=>item.lat === latG).lat = lat;
                        kmz.find(item=>item.lng === lngG).lng = lng;
                        
                        document.getElementById("kmz").value = JSON.stringify(kmz);
                        
                        poly.setMap(null);
                        poly = new google.maps.Polygon({
                            path: kmz,
                            strokeColor: '#FF0000',
                            strokeOpacity: 0.8,
                            strokeWeight: 3,
                            fillColor: '#FF0000',
                            fillOpacity: 0.35
                        });
                        
                        poly.setMap(map);
                        
                        
                    });
                }
               
            });
        </script>
        
        <!-- Obtener los Datos de la Capa -->
        <script type = "text/javascript">
            
            $('#btn-editar').click(function (e) {
                
                $("#opciones-capa").hide();
                $("#mostrar-capa").hide();
                $("#guardar-capa").show();
                $("#editar-capa").show();
                $("#paleta-colores").show();
                $("#borrar-ruta").show();
                
                var id_capa = $("#id_capa").val();
                
                $.ajax({
                    url: 'obtener_datos_capa.htm',
                    type: "POST",
                    dataType: 'json',
                    data: {id_capa: id_capa},
                    success: function (data) {
                        $("#id_capa").val(data.id_capa);
                        $("#nombre").val(data.nombre);
                        $("#rutaFoto").val(data.icon);
                        $('#previewImg2').html("<img style='width: 20px; height: 20px; margin: 6px;' src='" + data.icon + "' />");
                        $("#kmz").val(JSON.stringify(data.kmz));
                        
                        var kmz = JSON.parse(JSON.stringify(data.kmz));
                        var arrayKMZ = [];

                        for(var i in kmz){
                            arrayKMZ.push(kmz[i]);
                        }
                        
                        var coords = coordinates(arrayKMZ[0]);
                        var map = initMap();
                        var poly = Polygon(arrayKMZ);
                        poly.setMap(map);
                        var markers = Marker(arrayKMZ, map);
                        
                    }
                });
            });
        </script>
        
        <!-- Deshabilitar Capa -->
        <script type = "text/javascript">
            $('#btn-deshabilitar').click(function (e) {
                
                e.preventDefault();
                
                var id_capa = $("#id_capa").val();
                var estatus = $("#estatus").val();
                    
                if(estatus === '1'){
                    estatus = '0';
                } else{
                    estatus = '1';
                }
                
                var currentDate = new Date();
                var fecha_actualizacion = currentDate.getFullYear() + "-" + (('0' + (currentDate.getMonth() + 1)).slice(-2)) + "-" + ('0' + currentDate.getDate()).slice(-2) + " " + ("0" + currentDate.getHours()).slice(-2) + ":" + ("0" + currentDate.getMinutes()).substr(-2) + ":" + currentDate.getSeconds();        
                
                $.ajax({
                    url: 'deshabilitar_capa.htm',
                    type: "POST",
                    dataType: 'json',
                    data: {
                        id_capa: id_capa,
                        statusCapa: estatus,
                        fecha_actualizacion: fecha_actualizacion
                    },
                    success: function (data) {
                        var nombre = data.nombre;
                        if(estatus === '1'){
                            document.getElementById("msgExito").innerHTML = "Se ha habilitado la capa"+"&nbsp"+nombre;
                        } else{
                            document.getElementById("msgExito").innerHTML = "Se ha deshabilitado la capa"+"&nbsp"+nombre;
                        }
                        $('#modalExito').modal('show');
                        $('#modalExito').on('hidden.bs.modal', function () {
                            location.reload();
                        });
                    }
                });
            });
        </script>
        
        <!-- Eliminar Capa -->
        <script type = "text/javascript">
            $('#btn-eliminar').click(function (e) {
                e.preventDefault();
                
                var id_capa = $("#id_capa").val();

                $.ajax({
                    url: 'eliminar_capa.htm',
                    type: "POST",
                    dataType: 'json',
                    data: {
                        id_capa: id_capa
                    },
                    success: function (data) {
                        document.getElementById("msgExito").innerHTML = "Se ha eliminado la capa"+"&nbsp"+$("#capa-seleccionada").val(); 
                        $('#modalExito').modal('show');
                        $('#modalExito').on('hidden.bs.modal', function () {
                            location.reload();
                        });
                    }
                });
            });
        </script>
        
        <!-- Validar si el nombre de la capa existe -->
        <script type="text/javascript">
            function validarCapa(nombre) {
                var nombre = nombre.value;
                
                $.ajax({
                    url: 'validar_capa.htm',
                    type: 'POST',
                    dataType: "json",
                    data: {
                        nombre: nombre
                    },
                    success: function (data) {
                        
                        if(data.nombre){
                            document.getElementById("errorCapa").innerHTML = "La capa se encuentra registrada.";
                        }else{
                            document.getElementById("errorCapa").innerHTML = "";
                        }
                        
                    }, error: function (error) {
                        console.log(error);
                    }});
            }
        </script>
        
        <!-- Actualizar Datos de la Capa -->
        <script type = "text/javascript">
            
            $('#btn-guardar').click(function (e) {
                e.preventDefault();
                
                var id_capa = $("#id_capa").val();
                var nombre = $("#nombre").val();
                console.log(nombre);
                var kmz = $("#kmz").val();
                var rutaFoto = $("#rutaFoto").val();
                var file = $('#file').get(0).files[0];
                var currentDate = new Date();
                var fecha_actualizacion = currentDate.getFullYear() + "-" + (('0' + (currentDate.getMonth() + 1)).slice(-2)) + "-" + ('0' + currentDate.getDate()).slice(-2) + " " + ("0" + currentDate.getHours()).slice(-2) + ":" + ("0" + currentDate.getMinutes()).substr(-2) + ":" + currentDate.getSeconds();
                
                if(file === undefined){
                    var formData = new FormData();
                    formData.append('id_capa', id_capa);
                    formData.append('nombre', nombre);
                    formData.append('kmz', kmz);
                    formData.append('rutaFoto', rutaFoto);
                    formData.append('fecha_actualizacion', fecha_actualizacion);
                    
                    $.ajax({
                    url: 'editar_capa.htm',
                    type: "POST",
                    cache: false,
                    contentType: false,
                    processData: false,
                    data: formData,
                    success: function (data) {
                        document.getElementById("msgExito").innerHTML = "Se ha actualizado la capa"+"&nbsp"+$("#capa-seleccionada").val(); 
                        $('#modalExito').modal('show');
                        $('#modalExito').on('hidden.bs.modal', function () {
                            location.reload();
                        });
                    }, error: function (error) {
                        console.log(error); 
                    }});
                }else{
                   
                    var formData = new FormData();
                    formData.append('id_capa', id_capa);
                    formData.append('nombre', nombre);
                    formData.append('kmz', kmz);
                    formData.append('rutaFoto', rutaFoto);
                    formData.append('fecha_actualizacion', fecha_actualizacion);
                    formData.append('file', $('#file').get(0).files[0]);
                    
                    $.ajax({
                    url: 'editar_capa_file.htm',
                    type: "POST",
                    contentType: false,
                    processData: false,
                    cache: false,
                    data: formData,
                    success: function (data) {
                        document.getElementById("msgExito").innerHTML = "Se ha actualizado la capa"+"&nbsp"+$("#capa-seleccionada").val(); 
                        $('#modalExito').modal('show');
                        $('#modalExito').on('hidden.bs.modal', function () {
                            location.reload();
                        });
                    }, error: function (error) {
                        console.log(error.responseText);
                    }});
                }
            });
        </script>
    </body>

</html>