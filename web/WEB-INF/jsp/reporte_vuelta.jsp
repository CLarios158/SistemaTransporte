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
        <script async defer
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAdTfw1waJScSYaMdXKGqAW6rnHcwmjZwc&callback=initMap">
        </script>

        <!--link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"/-->
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/main.css" />
        <link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />

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
                    <ul class="menu">
                        <li><a class="nav-link" href="<c:url value="index.htm" />" ><i class="fas fa-map-marker-alt"></i> GPS</a></li>
                        <li><a class="nav-link" href="#"><i class="far fa-window-restore"></i> CAPAS <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="crear_capa.htm"><i class="fas fa-plus-circle"></i> CREAR NUEVA CAPA</a></li>
                                <li><a class="nav-link" href="consultar_capa.htm"><i class="fas fa-search"></i> CONSULTAR CAPA</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="#"><i class="fas fa-road"></i> RUTAS <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="crear_ruta.htm"><i class="fas fa-plus-circle"></i> CREAR NUEVA RUTA</a></li>
                                <li><a class="nav-link" href="consultar_ruta.htm"><i class="fas fa-search"></i> CONSULTAR RUTA</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="#"><i class="fas fa-map-marker-alt"></i> RAMALES <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="crear_ramal.htm"><i class="fas fa-plus-circle"></i> CREAR NUEVA RAMAL</a></li>
                                <li><a class="nav-link" href="consultar_ramal.htm"><i class="fas fa-search"></i> CONSULTAR RAMAL</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link"  href="#"><i class="fas fa-clipboard-list"></i> ITINERARIOS <i style="float: right;" class="fas fa-angle-down"></i></a>
                            <ul class="sub-menu">
                                <li><a class="nav-link" href="#"><i class="fas fa-plus-circle"></i> CREAR NUEVO ITINERARIO</a></li>
                                <li><a class="nav-link" href="#"><i class="fas fa-search"></i> CONSULTAR ITINERARIO</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="alerta.htm" ><i class="fas fa-exclamation-triangle"></i> ALERTAS</a></li>                        
                        <li><a class="nav-link" href="configurar_alerta.htm" ><i class="fas fa-cog"></i> CONFIGURACIÓN ALERTAS</a></li>
                        <li><a class="nav-link" href="<c:url value="index.htm" />" ><i class="fas fa-file-alt"></i> REPORTES</a></li>
                    </ul>
                </nav>
            </div>
            
            <!-- content -->        
            <div class="form-group">
                <nav class="nav nav-horizontal flex-row">
                    <a class="color-label" href="#"><i class="fas fa-home color-icon"></i>Reporte |</a>
                    <a class="color-label-bold" href="#" >Resumen de Vueltas</a>
                </nav>
                <div class="line"></div>
            </div>
            <div class="form-group center">
                <label class="text-white">Reportes</label>
            </div>
            <div class="form-group center">
                <div class="col-md-2">
                    <input type="radio" id="dia" name="dia">
                    <label style="font-size: 12px; margin-left: 10px;" class="col-form-label text-white">Día</label>
                    <div class="col-sm-8 input-icons">
                        <i class="fas fa-calendar icon-input"></i>
                        <input class="form-control" id="datepicker"  />                 
                    </div>
                </div>
                <div class="col-md-1">
                    <input type="radio" id="semanal" name="semanal">
                    <label style="font-size: 12px; margin-left: 10px;" class="col-form-label text-white">Semana</label> 
                    <!--<i style="color: orange;" class="fas fa-calendar"></i>-->
                </div>
                <div class="col-md-3">
                    <label style="font-size: 12px; margin-left: 10px;" class="col-form-label text-white">Buscar unidad:</label>
                    <div class="col-sm-8  input-icons">
                        <i class="fas fa-search icon-input"></i>
                        <input type="text" class="form-control" name="buscarUnidad" id="buscarUnidad" autocomplete="off">
                        <div style="z-index: 2; position: absolute; width: 90%;" class="list-group" id="show-list"></div>
                    </div>
                </div>
            </div>
            <div class="form-group center">
                <table class="table-alerta" style="width:80%">
                    <tr>
                        <th>Vueltas</th>
                        <th>Unidad</th>
                        <th>Inicio</th>
                        <th>Fin</th>
                        <th>Duración</th>
                        <th>Kms</th>
                        <th>Ruta</th>
                        <th>Ramal</th>
                        <th>No. Alertas</th>
                        <th>Pasaje / Km</th>
                        <th>Calificación</th>
                        
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>22</td>
                        <td>07:00:00</td>
                        <td>08:15:55</td>
                        <td>01:15:55</td>
                        <td>15</td>
                        <td>22</td>
                        <td>Arboledas</td>
                        <td>3</td>
                        <td>2.38</td>
                        <td>100</td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>21</td>
                        <td>07:00:00</td>
                        <td>08:10:00</td>
                        <td>01:10:00</td>
                        <td>20</td>
                        <td>21</td>
                        <td>Universidad</td>
                        <td>0</td>
                        <td>1.8</td>
                        <td>95</td>
                    </tr>
                </table>
            </div>
            <div class="form-group center">
                <p class="mb-2 text-white" style="font-size: 12px;">Descargar</p>
            </div>
            <div class="form-group center">
                <div class="card-buttons">
                    <button title="" id="PDF"><i class="fas fa-file-pdf"></i></button>
                    <button title="" id ="CSV"><i class="fas fa-file-excel"></i></button>
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

        <script
            src="https://code.jquery.com/jquery-3.4.1.js"
            integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
        crossorigin="anonymous"></script>        
        <script src="https://unpkg.com/gijgo@1.9.13/js/gijgo.min.js" type="text/javascript"></script>              
        <script src="https://unpkg.com/gijgo@1.9.13/js/messages/messages.es-es.js" type="text/javascript"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>
        
        <!-- DatePicker -->
        <script>
            $('#datepicker').datepicker({
                locale: 'es-es',
                format: 'dd/mm/yyyy',
                uiLibrary: 'bootstrap4',
                showOnFocus: true, 
                showRightIcon: false 
            });
        </script>

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

        <script type="text/javascript">
            $('#Aceptar').submit(function (evento) {
                evento.preventDefault();

                var warning = $("#filter-warning").is(':checked');
                var info = $("#filter-info").is(':checked');
                var danger = $("#filter-danger").is(':checked');
                var dias = $("#filter-days").val();
                console.log(warning);
                console.log(info);
                console.log(danger);
                console.log(dias);

                $.ajax({
                    url: 'listar_autos_interfazPrincipal.htm',
                    type: 'POST',
                    cache: false,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8;",
                    dataType: "json",
                    data: {
                        warning: warning,
                        info: info,
                        danger: danger,
                        dias: dias},
                    success: function (data) {
                        console.log(data);

                        var datos;
                        for (i in data.Alertas_Vehiculos) {
                            let icon;
                            if (data.Alertas_Vehiculos[i].tipo_registro == '3') {
                                icon = '<i class="fas fa-times-circle"></i>';
                            } else if (data.Alertas_Vehiculos[i].tipo_registro == '2') {
                                icon = '<i class="fas fa-exclamation-triangle"></i>';
                            } else if (data.Alertas_Vehiculos[i].tipo_registro == '1') {
                                icon = '<i class="fas fa-info-circle"></i>';
                            }
                            datos = datos + '<tr>' +
                                    '<td>' + icon + '</td>' +
                                    '<td>' +
                                    '<p>' + data.Alertas_Vehiculos[i].fecha_hora + '</p>' +
                                    '<a href="#" onClick="goToCoords(`' + data.Alertas_Vehiculos[i].coordenadas + '`)">' + data.Alertas_Vehiculos[i].nombre_arco + '</a>' +
                                    '</td>' +
                                    '<td>' +
                                    data.Alertas_Vehiculos[i].niv +
                                    '</td>' +
                                    '<td>' +
                                    data.Alertas_Vehiculos[i].Descripcion +
                                    '</td>' +
                                    '<td>' +
                                    data.Alertas_Vehiculos[i].fuente +
                                    '</td>' +
                                    '</tr>';
                        }

                        var datosArcos;
                        for (i in data.Alertas_Arcos) {
                            let icon;
                            if (data.Alertas_Arcos[i].tipo_registro == '3') {
                                icon = '<i class="fas fa-times-circle"></i>';
                            } else if (data.Alertas_Arcos[i].tipo_registro == '2') {
                                icon = '<i class="fas fa-exclamation-triangle"></i>';
                            } else if (data.Alertas_Arcos[i].tipo_registro == '1') {
                                icon = '<i class="fas fa-info-circle"></i>';
                            }
                            datosArcos = datosArcos + '<tr>' +
                                    '<td>' + icon + '</td>' +
                                    '<td>' +
                                    '<p>' + data.Alertas_Arcos[i].fecha_hora + '</p>' +
                                    '<p><a href="#" onClick="goToCoords(`' + data.Alertas_Arcos[i].coordenadas + '`)">' + data.Alertas_Arcos[i].nombre_arco + '</a>,' + data.Alertas_Arcos[i].nombre_alerta + '</p>' +
                                    '</td>' +
                                    '</tr>';
                        }

                        $("#tbAlertasAutos").html(datos);
                        $("#tbAlertasArcos").html(datosArcos);

                        console.log("Entro");
                    }, error: function (error) {
                        console.log("Aqui esta2");
                        console.log(error);
                    }
                })

            });
        </script>
    </body>

</html>

