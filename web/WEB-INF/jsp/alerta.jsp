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

        <!--link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"/-->
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
        <link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />
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
                <label class="text-white">Alertas del día <label style="color: #5EC7FF;">Unidad 03</label></label>
            </div>
            <div class="form-group center">
                <label style="font-size: 12px;" for="unidad" class=" col-form-label text-white">Buscar unidad:</label>
                <div class="col-sm-3 input-icons">
                    <i class="fas fa-search icon-input"></i>
                    <input type="text" class="form-control" name="buscarUnidad" id="buscarUnidad" autocomplete="off">
                    <div style="z-index: 2; position: absolute; width: 90%;" class="list-group" id="show-list"></div>
                </div>
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
        
        <!-- Modal-->
        <div class="modal fade" id="modalExito" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">
                        <div class="row form-group center">
                            <h6 class="text-white">Puntos de control en los que se paro la unidad</h6>
                        </div>
                        <div class="row form-group">
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Inicio:</label>
                            <div class="col-sm-4">
                                <input class="form-control" id="datepicker" width="150" />
                            </div>
                            
                            <label style="font-size: 12px;" class="text-white col-sm-1 col-form-label">Fin:</label>
                            <div class="col-sm-4">
                               <input class="form-control" id="datepicker2" width="150" />
                            </div>
                            <div class="col-sm-2">
                                <button style="margin: 0px;" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <div class="row form-group center">
                            <table id="table" class="table-alerta" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Número</th>
                                        <th>Hora</th>
                                        <th>Fecha</th>
                                        <th>Punto de Control</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1</td>
                                        <td>7:30 am</td>
                                        <td>06/08/2020</td>
                                        <td>Parque Hidalgo</td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>10:30 am</td>
                                        <td>07/08/2020</td>
                                        <td>Hospital Universitario</td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td>13:30 pm</td>
                                        <td>10/08/2020</td>
                                        <td>Paraninfo Universitario</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
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
        
        <script src="javascript/vendors/datatables.min.js"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>
        <script src="https://unpkg.com/gijgo@1.9.13/js/messages/messages.es-es.js" type="text/javascript"></script>
        
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
        
        <!--Buscar Unidad -->
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
                                    lista += '<a id="click-unidad" href="#" data-id="'+data[i].niv+'" class="list-group-item list-group-item-action border-1">'+data[i].niv+'</a>';
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
                
                $(document).on('click','a[id=click-unidad]', function(){
                    $("#buscarUnidad").val('');
                    var niv =  $(this).data("id");
                    $("#mostrar-tablas").show();
                    
                    $.ajax({
                        url: 'obtener_unidad_alerta.htm',
                        type: "POST",
                        data: { niv: niv }, 
                    success: function (data) {
                        var tr_unidad = "";
                        var tr_alcancia = "";
                        
                        for(var i in data.alertasUnidad){
                            tr_unidad += '<tr id=""><td class="ancho">'+data.alertasUnidad[i].nombre+'</td><td ><a href="#" data-role="openModal" data-niv="'+niv+'" data-id="'+data.alertasUnidad[i].id_mensajealerta+'" style="border-color: transparent; background-color: transparent; color: white;">'+data.alertasUnidad[i].cantidad+'</a></td></tr>';
                        }
                        
                        for(var i in data.alertasAlcancia){
                            tr_alcancia += '<tr id=""><td class="ancho">'+data.alertasAlcancia[i].nombre+'</td><td ><a href="#" data-role="openModal" data-niv="'+niv+'" data-id="'+data.alertasUnidad[i].id_mensajealerta+'" style="border-color: transparent; background-color: transparent; color: white;">'+data.alertasAlcancia[i].cantidad+'</a></td></tr>';
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
                
                        var tabla_alcancia = '<table id="table-unidad" class="table-alerta" style="width: 100%;"> \n' +
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
        
        <script>
            $('#datepicker').datepicker({
                uiLibrary: 'bootstrap4',
                locale: 'es-es',
                format: 'dd/mm/yyyy',
                size: 'small',
                icons: {
                    rightIcon: '<i style="color: #F5A623; font-size: 10px;" class="fas fa-calendar"></i>'
                }
            });
            
            $('#datepicker2').datepicker({
                uiLibrary: 'bootstrap4',
                locale: 'es-es',
                format: 'dd/mm/yyyy',
                size: 'small',
                icons: {
                    rightIcon: '<i style="color: #F5A623; font-size: 10px;" class="fas fa-calendar"></i>'
                }
            });
        </script>
                
        <script>
            $(document).on('click', 'a[data-role=openModal]', function () {
                
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
                    
                    console.log(data)
                    
                    var contador = 0;
                    var th = "";
                    var td = "";
                    
                    for(var i in data.datos){
                        th += '<th>'+Object.keys(data.datos)[contador]+'</th>';
                        contador++;
                    }
                    
                    console.log(th);
                    
                    for(var i in data.datos){
                        td += '<td>'+data.datos[i]+'</td>';
                    }
                    
                    console.log(td);
                }});
                
                //var id = $(this).data('id');
                //var nombre = $('#' + id).children('td[data-target=nombre]').text();
                //console.log(nombre)
                //var cantidad = $('#' + id).children('td[data-target=motivo]').text();

                //$('#id').val(id);
                //$('#movimiento').val(movimiento);
                //$('#motivo1').val(motivo);
                 $('#modalExito').modal('show');
            });
        </script>                                            
        
        <!-- Tablas -->
        <script>
            $(document).ready( function () {
                
                $('#table-unidad').DataTable({
                    "ordering": false,
                    "info":     false,
                    "searching": false,
                    "lengthChange": false,
                    "pagingType": "numbers",
                    "dom": '<"row view-filter"<"col-sm-12"<"pull-left"l><"pull-right"f><"clearfix">>>t<"row view-pager"<"col-sm-12"<"text-center"ip>>>'
                });
                
                $('#table-alcancia').DataTable({
                    "ordering": false,
                    "paging": false,
                    "info":     false,
                    "searching": false,
                    "lengthChange": false
                });
                
            } );
        </script>
        
    </body>

</html>
