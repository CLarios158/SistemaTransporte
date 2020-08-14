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
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAdTfw1waJScSYaMdXKGqAW6rnHcwmjZwc">
        </script>


        <!--link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"/-->
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/main.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />

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
            <div style="width: 30%;" class="slide-menu main-slide-menu show" id="main-slide-menu">
                <!--<a class="btn-slide-menu d-flex flex-no-wrap align-items-center" href="" data-toggle="slide-menu"
                   data-target="#main-slide-menu">
                    <i class="icon"></i>
                </a>-->
                <nav class="nav nav-horizontal flex-row">
                    <a class="color-label" href="<c:url value="index.htm" />"><i class="fas fa-home color-icon"></i>Capas |</a>
                    <a class="color-label-bold" href="<c:url value="crear_capa.htm" />" >Crear Capa</a>
                </nav>
                <div class="card main-slide-menu-card">
                    <form action="crear_capa.htm" id="myForm" name="myForm" onsubmit="return(validate());" method=POST enctype=multipart/form-data>
                        <div class="card-body">
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
                                    <div class="upload-img" id="previewImg"></div>
                                    <input type="file" id="file" name="file">
                                    <label class="btn-file" for="file">Cargar</label>
                                </div>
                            </div>
                            <input hidden type="text" id="kmz" name="kmz">
                        </div>
                        <div class="card-footer center">
                            <button type="button" class="btn btn-outline-primary">Cancelar</button>
                            <button id="guardar" type="submit" class="btn btn-primary">Guardar</button>
                        </div>
                    </form>
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
            <!--<div style="position: absolute; top: 5px; left: 31%; z-index: 5;">
                <div class="row">
                    <div class="col center">
                        <button style="color: white; background: transparent; border: 0px;"><i style="font-size: 20px;" class="fas fa-map-pin "></i></button>
                    </div> 
                </div>
            </div>-->
            <div style="position: absolute; top: 5px; left: 31%; z-index: 5;">
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
            <div id="btn-borrar" style="position: absolute; top: 92%; left: 30%; z-index: 5;">
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
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 12px;">Se ha creado la capa correctamente.</p></div>
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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>

        <!-- Crear Mapa  -->
        <script type="text/javascript">
            $(document).ready(function () {

                var location = {lat: 19.243772, lng: -103.714532};
                var poly;
                var lines = [];
                var markers = [];
                var kmz = [];
                var kmzJSON;
                var latG;
                var lngG;

                var map = new google.maps.Map(document.getElementById('map'), {
                    zoom: 13,
                    center: location,
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

                // Define polygon properties
                function Polygon() {
                    poly = new google.maps.Polygon({
                        strokeColor: '#FF0000',
                        strokeOpacity: 0.8,
                        strokeWeight: 3,
                        fillColor: '#FF0000',
                        fillOpacity: 0.35
                    });

                    poly.setMap(map);
                }

                Polygon();

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
                    
                    markers.push(marker);
                }
               

                function deleteMarket(map) {
                    for (var i = 0; i < markers.length; i++) {
                        markers[i].setMap(map);
                    }
                }

                $("#delete").click(function () {
                    kmz = [];
                    document.getElementById("kmz").value = "";
                    deleteMarket(null);
                    poly.setMap(null);
                    Polygon();
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
            });
        </script>

        <!-- Mostrar una previsualización del icono -->
        <script type="text/javascript">
            $(document).ready(function () {

                function filePreview(input) {
                    if (input.files && input.files[0]) {
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            $('#previewImg').html("<img style='width: 20px; height: 20px; margin: 6px;' src='" + e.target.result + "' />");
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

        <!-- Validar Formulario -->
        <script type = "text/javascript">
            function validate() {

                if (document.myForm.nombre.value === "") {
                    alert("Por favor ingresa el nombre!");
                    document.myForm.nombre.focus();
                    return false;
                }
                if (document.myForm.file.value === "") {
                    alert("Por favor carge el icono!");
                    document.myForm.file.focus();
                    return false;
                }
                if (document.myForm.kmz.value === "") {
                    alert("Por favor trace la ruta!");
                    document.myForm.kmz.focus();
                    return false;
                }

                return(true);
            }
        </script>

        <!-- Crear la capa -->
        <script type="text/javascript">
            $('#guardar').click(function (e) {

                e.preventDefault();

                var nombre = document.getElementById("nombre").value;
                var kmz = document.getElementById("kmz").value;
                var statusCapa = 1;
                var currentDate = new Date();
                var fecha_registro = currentDate.getFullYear() + "-" + (('0' + (currentDate.getMonth() + 1)).slice(-2)) + "-" + ('0' + currentDate.getDate()).slice(-2) + " " + ("0" + currentDate.getHours()).slice(-2) + ":" + ("0" + currentDate.getMinutes()).substr(-2) + ":" + currentDate.getSeconds();

                var formData = new FormData();
                formData.append('nombre', nombre);
                formData.append('kmz', kmz);
                formData.append('statusCapa', statusCapa);
                formData.append('fecha_registro', fecha_registro);
                formData.append('file', $("input[type=file]")[0].files[0]);

                if (validate()) {
                    $.ajax({
                        url: 'registrar_capa.htm',
                        type: "POST",
                        enctype: 'multipart/form-data',
                        processData: false, // Important!
                        contentType: false,
                        cache: false,
                        data: formData,
                        success: function (data) {
                            
                            $('#modalExito').modal('show');
                            $('#modalExito').on('hidden.bs.modal', function () {
                                location.reload();
                            });
                            console.log(data);
                        }, error: function (error) {
                            console.log(error);
                        }});
                }
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
                            $("#errorCapa").show();
                        }else{
                            document.getElementById("errorCapa").innerHTML = "";
                            $("#errorCapa").hide();
                        }
                        
                    }, error: function (error) {
                        console.log(error);
                    }});
            }
        </script>
    </body>

</html>