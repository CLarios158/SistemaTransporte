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
    </head>

    <body class="theme-dark" style="color:white;">
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
                        Arcos
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

        <div style="background-color: #05151C; height: 90%;">
            <a class="btn-slide-menu d-flex flex-no-wrap align-items-center" href="" data-toggle="slide-menu"
               data-target="#main-slide-menu">
                <i class="icon"></i>
            </a>
            <h6 class="p-4">Consulta de Lecturas por Vehículos</h6>
            <div class="card main-slide-menu-card" style="background-color:#0A1E28;">
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
                <div class="card-body" id="tablaPDF" style="color:white;">
                    <table id="tablacsv" class="table-arcos" >
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
                                    <button title="" id="CSV" download="your-foo.csv"><i class="fas fa-file-excel"></i></button>
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
                    fecha_inicial: fecha_inicial,
                    fecha_final: fecha_final,
                    id_arco: id_arco},
                success: function (data) {
                    console.log("Entrooo");

                    $("#TipoVehiculo").html(data.DatosVehiculo.Tipo);
                    $("#Marca").html(data.DatosVehiculo.Marca);
                    $("#Color").html(data.DatosVehiculo.Color);
                    $("#Placa").html(data.DatosVehiculo.Placa);
                    $("#Niv").html(data.DatosVehiculo.niv);

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
                                    '<a href="">' + data.DatosAlerta[i].nombre_arco + '</a>' +
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
                                    '<a href="">' + data.DatosAlerta[i].nombre_arco + '</a>' +
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
                                    '<a href="">' + data.DatosAlerta[i].nombre_arco + '</a>' +
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


                    if (check_niv == true) {
                        var placa_niv = '<div class="">' +
                                '<label for="Aceptar">' +
                                '<input name="check" id="check_niv" type="radio" checked>' +
                                'NIV:' + $("#placa_niv").val() +
                                '</label><br>';
                    }
                    if (check_placa == true) {
                        var placa_niv = '<div class="">' +
                                '<label for="Aceptar">' +
                                '<input name="check" id="check_placa" type="radio" checked>' +
                                'PLACA' + $("#placa_niv").val() +
                                '</label>' +
                                '</div>';
                    }

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
                    var csv= ',Consulta de lectura por placa,Fecha reporte:,'+ +'\n\n';
                    csv= csv+ ',,Datos del vehiculo\n';
                    csv= csv+ 'Tipo de vehiculo,Marca,Color,Placa,NIV\n';
                    csv= csv+ data.DatosVehiculo.Tipo + ',' + data.DatosVehiculo.Marca + ',' + data.DatosVehiculo.Color + ',' + data.DatosVehiculo.Placa + ',' + data.DatosVehiculo.niv + '\n\n';
                    csv= csv+ ',,Filtros\n';
                    csv= csv+ 'Arcos,Fecha inicial, Fecha final\n';
                    csv= csv+ id_arco + ',' + fecha_inicial1 + ',' + fecha_final1 + '\n\n';
                            
                    csv= csv+ 'Tipo,Fecha y hora, Arco,Descripcion,Fuente de informacion\n';
                    for (i in data.DatosAlerta) {
                        if (data.DatosAlerta[i].fuente == null) {
                            fuente = ''
                        } else {
                            fuente = data.DatosAlerta[i].fuente;
                        }
                        
                        if(data.DatosAlerta[i].tipo_registro == '1'){
                            tipo= 'Informativo';
                        }else if (data.DatosAlerta[i].tipo_registro == '2'){
                            tipo= 'Advertencia';
                        }else if(data.DatosAlerta[i].tipo_registro == '3'){
                            tipo= 'Critico';
                        }
                        
                        csv = csv + tipo + ',' + data.DatosAlerta[i].fecha_hora + ',' + data.DatosAlerta[i].nombre_arco + ',' + data.DatosAlerta[i].Descripcion + ',' + fuente + '\n';
                    }
                    
                    
                    console.log(csv);
                    
                    var data = $("tablacsv").first(); //Only one table
                    var csvData = [];
                    var tmpArr = [];
                    var tmpStr = '';
                    data.find("tr").each(function() {
                        var th=$("tablacsv").find("th");
                        if(th.length) {
                            th.each(function() {
                              tmpStr = $("tablacsv").text().replace(/"/g, '""');
                              tmpArr.push('"' + tmpStr + '"');
                            });
                            csvData.push(tmpArr);
                        } else {
                            tmpArr = [];
                               $("tablacsv").find("td").each(function() {
                                    if($("tablacsv").text().match(/^-{0,1}\d*\.{0,1}\d+$/)) {
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