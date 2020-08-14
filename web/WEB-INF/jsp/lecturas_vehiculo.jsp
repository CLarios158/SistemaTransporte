<%@page import="Config.Conexion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("login.htm");
    }
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <title>Arcos</title>

        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/main.min.css" />
        <!--script async defer
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBmfHYRwI0W_LcU9fDiQrTWJjuQvkDy1aE&callback=initMap">
        </script-->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"/>
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>

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
                            <span class="d-block"><%= session.getAttribute("usuario")%></span>
                            <a class="mn-logout-link" href="<c:url value="logout.htm" />">cerrar sesión</a>
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
                    <div class="col-md-1">
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
                    <div class="col-md-5">
                        <div class="cn-wrapper">
                            <div class="">
                                <select  name="select">
                                    <option value="unidad" selected>Seleccionar unidad</option> 
                                    <option value="value1">Value 1</option> 
                                    <option value="value2">Value 2</option>
                                    <option value="value3">Value 3</option>
                                </select>
                            </div>
                            <div class="pl-1" style="">
                                <select class="form-control" name="select">
                                    <option value="unidad" selected>Seleccionar ruta</option> 
                                    <option value="value1">Value 1</option> 
                                    <option value="value2">Value 2</option>
                                    <option value="value3">Value 3</option>
                                </select>
                            </div>
                            <div class="" ">
                                <select class="form-control" name="select">
                                    <option value="unidad" selected>Seleccionar ramal</option> 
                                    <option value="value1">Value 1</option> 
                                    <option value="value2">Value 2</option>
                                    <option value="value3">Value 3</option>
                                </select>
                            </div>
                        </div>
                    </div>      



                    <div class="col-md-5">
                        <div class="cn-wrapper">
                            <%
                                try {
                                    ResultSet r = Conexion.query("select * from sp_acceso_datos_db()");
                                    while (r.next()) {
                                        if (r.getString(2).equals("1")) {%>
                            <div class="display-status">
                                <i class="ds-icon ds-success"></i>
                                <span class="ds-msg"> <%= r.getString(1)%></span>
                            </div>
                            <%
                            } else if (r.getString(2).equals("0")) {%>
                            <div class="display-status"> 
                                <i class="ds-icon ds-danger"></i>
                                <span class="ds-msg"><%= r.getString(1)%></span>
                            </div>
                            <%
                                        }
                                    }
                                    r.close();
                                } catch (Exception e) {
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <main>
            <div class="slide-menu main-slide-menu" id="main-slide-menu">
                <a class="btn-slide-menu d-flex flex-no-wrap align-items-center" href="" data-toggle="slide-menu"
                   data-target="#main-slide-menu">
                    <i class="icon"></i>
                </a>
                <h6 class="p-4">Consulta de Lecturas por Vehículos</h6>
                <div class="card main-slide-menu-card">
                    <div class="card-header">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-md-11 d-flex justify-content-between align-items-end">
                                    <div class="pl-1 pr-1">
                                        <div class="d-flex justify-content-between">
                                            <label for="Aceptar">
                                                <input name="check" id="check_niv" type="radio">
                                                NIV
                                            </label>
                                            <label for="Aceptar">
                                                <input name="check" id="check_placa" type="radio">
                                                PLACA
                                            </label>
                                        </div>
                                        <input id="placa_niv" class="form-control" type="text" placeholder="Placa/Niv">
                                    </div>
                                    <div class="pl-1 pr-1">
                                        <label  for="Aceptar">Fecha y hora inicial</label>
                                        <input id="fecha_hora_inicial" class="form-control" type="datetime-local">
                                    </div>
                                    <div class="pl-1 pr-1">
                                        <label  for="Aceptar">Fecha y hora final</label>
                                        <input id="fecha_hora_final" class="form-control" type="datetime-local">
                                    </div>
                                    <div class="pl-1 pr-1" style="min-width: 120px;">
                                        <label for="Aceptar">Arcos</label>
                                        <select class="form-control" name="" id="check_arco">
                                            <option value="todos">Todos</option>
                                            <%
                                                try {
                                                    ResultSet r = Conexion.query("select * from sp_consultar_arcos()");
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
                                <div class="col-md-1 p-0 d-flex justify-content-center align-items-end card-actions">
                                    <button title="" class="action-filter m-0"><i class="fas fa-filter"></i></button>
                                </div>
                            </div>
                            <div class="row table-filters pt-3 pb-3">
                                <div class="col-md-3">
                                    <label class="noselect" for="filter-danger">
                                        <i class="fas fa-times-circle text-danger"></i>
                                        <input id="filter-danger" type="checkbox">
                                        Critico
                                    </label>
                                </div>
                                <div class="col-md-3">
                                    <label class="noselect" for="filter-info">
                                        <i class="fas fa-info-circle text-info"></i>
                                        <input id="filter-info" type="checkbox">
                                        Informativo
                                    </label>
                                </div>
                                <div class="col-md-3">
                                    <label class="noselect" for="filter-warning">
                                        <i class="fas fa-exclamation-triangle text-warning"></i>
                                        <input id="filter-warning" type="checkbox">
                                        Advertencia
                                    </label>
                                </div>
                                <form id="Aceptar" class="col-md-3" action="#">
                                    <button type="submit"  class="btn btn-primary">BUSCAR</button>
                                </form>

                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="table-arcos-head d-flex flex-wrap justify-content-between text-light">
                                        <p>
                                            Tipo de Vehículo: <strong id="TipoVehiculo"></strong>
                                        </p>
                                        <p>
                                            Marca: <strong id="Marca"></strong>
                                        </p>
                                        <p>
                                            Color: <strong id="Color"></strong>
                                        </p>
                                        <p>
                                            Placa: <strong id="Placa"></strong>
                                        </p>
                                        <p>
                                            NIV: <strong id="Niv"></strong>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-body" id="tablaPDF">
                        <table id="tablacsv" class="table-arcos">
                            <tbody id="tbDatosAlerta">


                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer center">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-2" style="font-size: 10px;">
                                        Descargar
                                    </p>
                                    <div class="card-actions">
                                        <button title="" id="PDF"><i class="fas fa-file-pdf"></i></button>
                                        <button title="" id="CSV"><i class="fas fa-file-excel"></i></button>
                                        <a class="fas fa-external-link-square-alt" href="/Sis_Arcos/lecturas_vehiculo_detalle.htm" target="_blank"><i class=""></i></a>
                                        <!-- <button title=""><i class="fas fa-external-link-square-alt"></i></button> -->
                                    </div>
                                </div>
                                <div class="col-md-6 d-flex align-items-end">
                                    <button class="btn btn-outline-primary text-uppercase">ver todo el historico</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- main slide nav -->
            <div class="slide-menu main-slide-nav" id="main-slide-nav">
                <nav class="nav flex-column">
                    <a class="nav-link" href="/Sis_Arcos/index.htm"><i class="fas fa-home"></i> TABLERO</a>
                    <a class="nav-link active" href="/Sis_Arcos/lecturas_vehiculo.htm"><i class="fas fa-car"></i> LECTURAS POR VEHÍCULO</a>
                    <a class="nav-link" href="/Sis_Arcos/lecturas_arco.htm"><i class="fas fa-archway"></i> LECTURAS POR ARCO</a>
                </nav>
            </div>

            <!-- map-container -->
            <div class="map-container" id="map" style="z-index: 1">
            </div>

        </main>

        <!--<script async defer
                src="https://snazzymaps.com/embed/29351"></script>-->
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
                <a href="arcos/" class="menu-item"><i class="fas fa-archway"></i></a>
            </menu>
        </div>
        <!-- end circular-menu -->

        <script defer>
            var map = L.map('map').setView([19.243772, -103.714532], 13);
            L.tileLayer('https://api.maptiler.com/maps/basic/256/{z}/{x}/{y}.png?key=5gUlBqllT3j0VghZnqHf', {
                attribution: '<a href="https://www.maptiler.com/copyright/" target="_blank">&copy; MapTiler</a> <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap contributors</a>'
            }).addTo(map);

            <c:forEach var="arco" items="${arcos}">
            L.marker([${arco.getLatitud()}, ${arco.getLongitud()}]).bindTooltip("<b>${arco.getNombre()}</b><br>${arco.getDescripcion()}.", {permanent: true, direction: 'top'}).addTo(map);
            </c:forEach>

            function goToCoords(coords) {
                let arr = coords.split(", ");
                let lat = +arr[0];
                let lon = +arr[1];
                map.flyTo([lat, lon], 17);
                $('#main-slide-menu').toggleClass('show');
            }

        </script>

        <script
            src="https://code.jquery.com/jquery-3.4.1.js"
            integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
        crossorigin="anonymous"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>


        <script type="text/javascript">
            $('#Aceptar').submit(function (evento) {
                evento.preventDefault();

                var placa_niv = $("#placa_niv").val();
                var check_niv = $("#check_niv").is(':checked');
                var check_placa = $("#check_placa").is(':checked');
                var warning = $("#filter-warning").is(':checked');
                var info = $("#filter-info").is(':checked');
                var danger = $("#filter-danger").is(':checked');
                var fecha_inicial = $("#fecha_hora_inicial").val();
                var fecha_final = $("#fecha_hora_final").val();
                var id_arco = $("#check_arco").val();

                var fecha_inicial1 = fecha_inicial.slice(0, 10) + ' ' + fecha_inicial.slice(11, 16);
                var fecha_final1 = fecha_final.slice(0, 10) + ' ' + fecha_final.slice(11, 16);

                $.ajax({

                    url: 'consultar_vehiculo.htm',
                    type: 'POST',
                    cache: false,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8;",
                    dataType: "json",
                    data: {
                        placa: $("#placa_niv").val(),
                        check_niv: check_niv,
                        check_placa: check_placa,
                        warning: warning,
                        info: info,
                        danger: danger,
                        fecha_inicial: fecha_inicial1,
                        fecha_final: fecha_final1,
                        id_arco: id_arco},
                    success: function (data) {
                        //console.log(data.0.fuente);
                        //var datax = JSON.parse(data.replace(/ 0+(?![\. }])/g, ' '));

                        $("#TipoVehiculo").html(data.DatosVehiculo.Tipo);
                        $("#Marca").html(data.DatosVehiculo.Marca);
                        $("#Color").html(data.DatosVehiculo.Color);
                        $("#Placa").html(data.DatosVehiculo.Placa);
                        $("#Niv").html(data.DatosVehiculo.niv);

                        console.log(Object.keys(data.DatosAlerta).length);
                        //data.DatosAlerta.forEach(function(element){
                        //  console.log();
                        //});
                        var datos;
                        var fuente;
                        for (i in data.DatosAlerta) {
                            if (data.DatosAlerta[i].fuente == null) {
                                fuente = ''
                            } else {
                                fuente = data.DatosAlerta[i].fuente;
                            }
                            let icon;
                            if (data.DatosAlerta[i].tipo_registro == '1') {
                                icon = '<i class="fas fa-info-circle"></i>';
                            } else if (data.DatosAlerta[i].tipo_registro == '2') {
                                icon = '<i class="fas fa-exclamation-triangle"></i>';
                            } else if (data.DatosAlerta[i].tipo_registro == '3') {
                                icon = '<i class="fas fa-times-circle"></i>';
                            }
                            datos = datos + '<tr>' +
                                    '<td>' + icon + '</td>' +
                                    '<td>' +
                                    '<p>' + data.DatosAlerta[i].fecha_hora + '</p>' +
                                    '<a href="#" onclick="goToCoords(`' + data.DatosAlerta[i].coordenadas + '`)">' + data.DatosAlerta[i].nombre_arco + '</a>' +
                                    '</td>' +
                                    '<td>' +
                                    data.DatosAlerta[i].Descripcion +
                                    '</td>' +
                                    '<td>' +
                                    fuente +
                                    '</td>' +
                                    '</tr>';
                            $("#tbDatosAlerta").html(datos);
                        }



                    }, error: function (error) {
                        console.log("Aqui esta2");
                        console.log(error);
                    }

                })

            });

            $('#PDF').click(function (evento) {
                evento.preventDefault();

                var placa_niv = $("#placa_niv").val();
                var check_niv = $("#check_niv").is(':checked');
                var check_placa = $("#check_placa").is(':checked');
                var warning = $("#filter-warning").is(':checked');
                var info = $("#filter-info").is(':checked');
                var danger = $("#filter-danger").is(':checked');
                var fecha_inicial = $("#fecha_hora_inicial").val();
                var fecha_final = $("#fecha_hora_final").val();
                var id_arco = $("#check_arco").val();

                var fecha_inicial1 = fecha_inicial.slice(0, 10) + ' ' + fecha_inicial.slice(11, 16);
                var fecha_final1 = fecha_final.slice(0, 10) + ' ' + fecha_final.slice(11, 16);

                $.ajax({

                    url: 'consultar_vehiculo.htm',
                    type: 'POST',
                    cache: false,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8;",
                    dataType: "json",
                    data: {
                        placa: $("#placa_niv").val(),
                        check_niv: check_niv,
                        check_placa: check_placa,
                        warning: warning,
                        info: info,
                        danger: danger,
                        fecha_inicial: fecha_inicial1,
                        fecha_final: fecha_final1,
                        id_arco: id_arco},
                    success: function (data) {
                        console.log(Object.keys(data.DatosAlerta).length);

                        var datos;
                        var fuente;
                        for (i in data.DatosAlerta) {
                            if (data.DatosAlerta[i].fuente == null) {
                                fuente = ''
                            } else {
                                fuente = data.DatosAlerta[i].fuente;
                            }

                            if (data.DatosAlerta[i].tipo_registro == '1') {
                                datos = datos + '<tr>' +
                                        '<td>' +
                                        '<i class="fas fa-info-circle"></i>' +
                                        '</td>' +
                                        '<td>' +
                                        '<p>' + data.DatosAlerta[i].fecha_hora + '</p>' +
                                        '<p>' + data.DatosAlerta[i].nombre_arco + '</p>' +
                                        '</td>' +
                                        '<td>' +
                                        data.DatosAlerta[i].Descripcion +
                                        '</td>' +
                                        '<td>' +
                                        fuente +
                                        '</td>' +
                                        '</tr>';
                                $("#tbDatosAlerta").html(datos);
                            } else if (data.DatosAlerta[i].tipo_registro == '2') {
                                datos = datos + '<tr>' +
                                        '<td>' +
                                        '<i class="fas fa-exclamation-triangle"></i>' +
                                        '</td>' +
                                        '<td>' +
                                        '<p>' + data.DatosAlerta[i].fecha_hora + '</p>' +
                                        '<p>' + data.DatosAlerta[i].nombre_arco + '</p>' +
                                        '</td>' +
                                        '<td>' +
                                        data.DatosAlerta[i].Descripcion +
                                        '</td>' +
                                        '<td>' +
                                        fuente +
                                        '</td>' +
                                        '</tr>';
                                $("#tbDatosAlerta").html(datos);
                            } else if (data.DatosAlerta[i].tipo_registro == '3') {
                                datos = datos + '<tr>' +
                                        '<td>' +
                                        '<i class="fas fa-times-circle"></i>' +
                                        '</td>' +
                                        '<td>' +
                                        '<p>' + data.DatosAlerta[i].fecha_hora + '</p>' +
                                        '<p>' + data.DatosAlerta[i].nombre_arco + '</p>' +
                                        '</td>' +
                                        '<td>' +
                                        data.DatosAlerta[i].Descripcion +
                                        '</td>' +
                                        '<td>' +
                                        fuente +
                                        '</td>' +
                                        '</tr>';
                                $("#tbDatosAlerta").html(datos);
                            }
                        }

                        var sTable = document.getElementById('tablaPDF').innerHTML;
                        var style = "<style>";
                        style = style + "table {width: 100%;font: 17px Calibri;}";
                        style = style + "table, th, td {border: solid 1px #DDD; border-collapse: collapse;";
                        style = style + "padding: 2px 3px;text-align: center;}";
                        style = style + "</style>";

                        // CREATE A WINDOW OBJECT.
                        var win = window.open('', '', 'height=700,width=700');

                        var f = new Date();
                        win.document.write('Fecha del reporte: ' + f.getDate() + "/" + (f.getMonth() + 1) + "/" + f.getFullYear() + ' - ' + f.getHours() + ':' + f.getMinutes() + ':' + f.getSeconds());

                        win.document.write('<html><head>' +
                                '<link rel="stylesheet" href="css/main.min.css" />' +
                                '<link rel="stylesheet" href="css/bootstrap.min.css">');
                        win.document.write('<title>Lectura vehículo</title>');   // <title> FOR PDF HEADER.
                        win.document.write(style);
                        win.document.write('</head>');
                        win.document.write('<body>');
                        win.document.write('<br><br><img  src="images/logo-kiotrack-color.png" style="height: 33px; width: 239px;" alt="kiotrack-logo-login">');
                        win.document.write('<br><p><b>Arcos: </b></p>');
                        if (id_arco == 'todos') {
                            win.document.write('<p align="left">Todos los Arcos.</p>');
                            win.document.write('<p align="right"> Fecha inicial: ' + fecha_inicial + ' - Fecha final: ' + fecha_final + '</p>');
                            win.document.write('</div>');
                        } else {
                            var nombre_arco = $('#check_arco option:selected').text();
                            win.document.write('<p>Nombre del arco: ' + nombre_arco + '</p>');
                            win.document.write('<p align="right"> Fecha inicial: ' + fecha_inicial + ' - Fecha final: ' + fecha_final + '</p>');
                            win.document.write('</div>');
                        }

                        var datos_vehiculo = '<div class="row">' +
                                '<div class="col-md-12" style="color:black;">' +
                                '<div class="table-arcos-head d-flex flex-wrap justify-content-between">' +
                                '<p>' +
                                'Tipo de Vehículo: <strong>' + data.DatosVehiculo.Tipo + '</strong>' +
                                '</p>' +
                                '<p>' +
                                'Marca: <strong>' + data.DatosVehiculo.Marca + '</strong>' +
                                '</p>' +
                                '<p>' +
                                'Color: <strong>' + data.DatosVehiculo.Color + '</strong>' +
                                '</p>' +
                                '<p>' +
                                'Placa: <strong>' + data.DatosVehiculo.Placa + '</strong>' +
                                '</p>' +
                                '<p>' +
                                'NIV: <strong>' + data.DatosVehiculo.niv + '</strong>' +
                                '</p>' +
                                '</div>' +
                                '</div>' +
                                '</div>';

                        if (warning == true) {
                            warningPDF = '<input id="filter-warning" type="checkbox" checked>';
                        } else {
                            warningPDF = '<input id="filter-warning" type="checkbox">';
                        }
                        var infoPDF
                        if (info == true) {
                            infoPDF = '<input id="filter-info" type="checkbox" checked>';
                        } else {
                            infoPDF = '<input id="filter-info" type="checkbox">';
                        }
                        var dangerPDF
                        if (danger == true) {
                            dangerPDF = '<input id="filter-danger" type="checkbox" checked>';
                        } else {
                            dangerPDF = '<input id="filter-danger" type="checkbox">';
                        }



                        var filtros = '<div class="" align="center">' +
                                placa_niv + '        ' +
                                '<label class="noselect" for="Buscar">' +
                                '<i class="fas fa-times-circle text-danger"></i>' +
                                dangerPDF +
                                'Critico &nbsp;' +
                                '</label>' +
                                '<label class="noselect" for="Buscar">' +
                                '<i class="fas fa-info-circle text-info"></i>' +
                                infoPDF +
                                'Informativo &nbsp;' +
                                '</label>' +
                                '<label class="noselect" for="Buscar">' +
                                '<i class="fas fa-exclamation-triangle text-warning"></i>' +
                                warningPDF +
                                'Advertencia &nbsp;' +
                                '</label>' +
                                '</div>';

                        win.document.write(datos_vehiculo);
                        win.document.write('<div class="container">' + filtros + '</div><br>');         // THE TABLE CONTENTS INSIDE THE BODY TAG.
                        win.document.write(sTable);         // THE TABLE CONTENTS INSIDE THE BODY TAG.
                        win.document.write('</body></html>');

                        win.document.close(); 	// CLOSE THE CURRENT WINDOW.

                        win.print();    // PRINT THE CONTENTS.

                    }, error: function (error) {
                        console.log("Aqui esta2");
                        console.log(error);
                    }

                })

            });

            $('#CSV').click(function (evento) {
                evento.preventDefault();

                var placa_niv = $("#placa_niv").val();
                var check_niv = $("#check_niv").is(':checked');
                var check_placa = $("#check_placa").is(':checked');
                var warning = $("#filter-warning").is(':checked');
                var info = $("#filter-info").is(':checked');
                var danger = $("#filter-danger").is(':checked');
                var fecha_inicial = $("#fecha_hora_inicial").val();
                var fecha_final = $("#fecha_hora_final").val();
                var id_arco = $("#check_arco").val();

                var fecha_inicial1 = fecha_inicial.slice(0, 10) + ' ' + fecha_inicial.slice(11, 16);
                var fecha_final1 = fecha_final.slice(0, 10) + ' ' + fecha_final.slice(11, 16);

                $.ajax({

                    url: 'consultar_vehiculo.htm',
                    type: 'POST',
                    cache: false,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8;",
                    dataType: "json",
                    data: {
                        placa: $("#placa_niv").val(),
                        check_niv: check_niv,
                        check_placa: check_placa,
                        warning: warning,
                        info: info,
                        danger: danger,
                        fecha_inicial: fecha_inicial1,
                        fecha_final: fecha_final1,
                        id_arco: id_arco},
                    success: function (data) {
                        console.log(Object.keys(data.DatosAlerta).length);

                        var datos;
                        var fuente;
                        var csv = ',,Datos del vehiculo\n';
                        csv = csv + 'Tipo de vehiculo,Marca,Color,Placa,NIV\n';
                        csv = csv + data.DatosVehiculo.Tipo + ',' + data.DatosVehiculo.Marca + ',' + data.DatosVehiculo.Color + ',' + data.DatosVehiculo.Placa + ',' + data.DatosVehiculo.niv + '\n\n';
                        csv = csv + ',,Filtros\n';
                        csv = csv + 'Arcos,Fecha inicial, Fecha final\n';
                        csv = csv + id_arco + ',' + fecha_inicial1 + ',' + fecha_final1 + '\n\n';

                        csv = csv + 'Tipo,Fecha y hora, Arco,Descripcion,Fuente de informacion\n';
                        for (i in data.DatosAlerta) {
                            if (data.DatosAlerta[i].fuente == null) {
                                fuente = ''
                            } else {
                                fuente = data.DatosAlerta[i].fuente;
                            }

                            if (data.DatosAlerta[i].tipo_registro == '1') {
                                tipo = 'Informativo';
                            } else if (data.DatosAlerta[i].tipo_registro == '2') {
                                tipo = 'Advertencia';
                            } else if (data.DatosAlerta[i].tipo_registro == '3') {
                                tipo = 'Critico';
                            }

                            csv = csv + tipo + ',' + data.DatosAlerta[i].fecha_hora + ',' + data.DatosAlerta[i].nombre_arco + ',' + data.DatosAlerta[i].Descripcion + ',' + fuente + '\n';
                        }


                        console.log(csv);

                        var data = $("tablacsv").first(); //Only one table
                        var csvData = [];
                        var tmpArr = [];
                        var tmpStr = '';
                        data.find("tr").each(function () {
                            var th = $("tablacsv").find("th");
                            if (th.length) {
                                th.each(function () {
                                    tmpStr = $("tablacsv").text().replace(/"/g, '""');
                                    tmpArr.push('"' + tmpStr + '"');
                                });
                                csvData.push(tmpArr);
                            } else {
                                tmpArr = [];
                                $("tablacsv").find("td").each(function () {
                                    if ($("tablacsv").text().match(/^-{0,1}\d*\.{0,1}\d+$/)) {
                                        tmpArr.push(parseFloat($("tablacsv").text()));
                                    } else {
                                        tmpStr = $("tablacsv").text().replace(/"/g, '""');
                                        tmpArr.push('"' + tmpStr + '"');
                                    }
                                });
                                csvData.push(tmpArr.join(','));
                            }
                        });
                        var output = csvData.join('\n');
                        var uri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
                        var downloadLink = document.createElement("a");
                        downloadLink.href = uri;
                        downloadLink.download = document.title ? document.title.replace(/ /g, "_") + ".csv" : "data.csv";
                        document.body.appendChild(downloadLink);
                        downloadLink.click();
                        document.body.removeChild(downloadLink);

                    }, error: function (error) {
                        console.log("Aqui esta2");
                        console.log(error);
                    }

                })

            });


        </script>
    </body>

</html>