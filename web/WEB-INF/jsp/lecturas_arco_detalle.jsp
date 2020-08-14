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
        <title>Arcos</title>

        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/main.min.css" />
    </head>

    <body class="theme-dark" style="color:white;">
        <!-- top bar -->
        <nav class="main-navbar navbar navbar-expand-lg">
            <a class="navbar-brand" href="index.htm">
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
                            <a class="mn-logout-link" href="<c:url value="logout.htm" />">cerrar sesion</a>
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
            <h6 class="p-4" style="color:white;">Consulta de Lecturas por Arcos</h6>
            <div class="card main-slide-menu-card" style="background-color:#0A1E28;">
                <div class="card-header">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-3">
                                <label for="Buscar">Fecha y hora inicial</label>
                                <input id="fecha_inicial" class="form-control" type="datetime-local" >
                            </div>
                            <div class="col-md-3">
                                <label for="Buscar">Fecha y hora final</label>
                                <input id="fecha_final" class="form-control" type="datetime-local">
                            </div>
                            <div class="col-md-3">
                                <label for="Buscar">Arcos</label>
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
                            <div class="col-md-3">
                                <label for="Buscar">Color</label>
                                <select class="form-control" name="" id="check-color">
                                    <%
                                        try {
                                            ResultSet r = Conexion.query("select u.color from unidad_registro_repuve u group by u.color");
                                            while (r.next()) {%>
                                    <option value=<%= r.getString(1)%>><%= r.getString(1)%></option>
                                    <%}
                                            r.close();
                                        } catch (Exception e) {
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div class="row table-filters pt-3 pb-1">
                            <div class="col-md-6">
                                <div class="d-flex">
                                    <div class="d-flex justify-content-start align-items-end card-actions">
                                        <button title="" class="action-filter m-0"><i class="fas fa-filter"></i></button>
                                    </div>
                                    <div class="d-flex table-filters pl-1">
                                        <label class="noselect" for="Buscar">
                                            <i class="fas fa-times-circle text-danger"></i>
                                            <input id="filter-danger" type="checkbox">
                                            Critico
                                        </label>
                                        <label class="noselect" for="Buscar">
                                            <i class="fas fa-info-circle text-info"></i>
                                            <input id="filter-info" type="checkbox">
                                            Informativo
                                        </label>
                                        <label class="noselect" for="Buscar">
                                            <i class="fas fa-exclamation-triangle text-warning"></i>
                                            <input id="filter-warning" type="checkbox">
                                            Advertencia
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 d-flex">
                                <div class="flex-grow-1 d-flex pt-2">
                                    <input id="Motocicleta" type="checkbox" class="fas fa-motorcycle check-icon">
                                    <input id="Carro" type="checkbox" class="fas fa-car check-icon">
                                    <input id="Taxi" type="checkbox" class="fas fa-taxi check-icon">
                                    <input id="Camion" type="checkbox" class="fas fa-bus-alt check-icon">
                                    <input id="Camioneta" type="checkbox" class="fas fa-truck-pickup check-icon">
                                    <!--<input id="camion" type="checkbox" class="fas fa-truck check-icon">-->
                                </div>
                                <button class="btn btn-outline-primary">
                                    TODOS
                                </button>
                            </div>
                        </div>

                        <div class="row pb-3">
                            <div class="offset-md-8 col-md-4">
                                <form id="Buscar" class="col-md-3" action="#">
                                    <button type="submit" class="btn btn-primary">
                                        BUSCAR
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container" id="tablaPDF">
                    <table id="tablacsv" class="table-arcos">
                        <thead>
                        <th>Tipo</th>
                        <th>Fecha y arco</th>
                        <th>Placa/Niv</th>
                        <th>Descripción</th>
                        <th>Fuente de información</th>
                        </thead>
                        <tbody id="tbAlertasVehiculos">

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
                                    <button title="" id ="CSV"><i class="fas fa-file-excel"></i></button>
                                </div>
                            </div>
                            <div class="col-md-6 d-flex align-items-end">
                                <button class="btn btn-outline-primary text-uppercase">ver todo el histórico</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

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

        <script src="https://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>

        <script type="text/javascript">

        $('#Buscar').submit(function (evento) {
            evento.preventDefault();

            var fecha_inicial = $("#fecha_inicial").val();
            var fecha_final = $("#fecha_final").val();
            var warning = $("#filter-warning").is(':checked');
            var info = $("#filter-info").is(':checked');
            var danger = $("#filter-danger").is(':checked');
            var id_arco = $("#check_arco").val();
            var Motocicleta = $("#Motocicleta").is(':checked');
            var Carro = $("#Carro").is(':checked');
            var Taxi = $("#Taxi").is(':checked');
            var Camion = $("#Camion").is(':checked');
            var Camioneta = $("#Camioneta").is(':checked');
            var color = $("#check-color").val();


            if (fecha_inicial.length == 16) {
                if (fecha_final.length == 16) {
                    var fecha_inicial1 = fecha_inicial.slice(0, 10) + ' ' + fecha_inicial.slice(11, 16);
                    var fecha_final1 = fecha_final.slice(0, 10) + ' ' + fecha_final.slice(11, 16);
                } else {
                    alert('Fecha final ingresada incorrectamente.');
                }
            } else {
                alert('Fecha inicial ingresada incorrectamente.');
            }
            console.log(fecha_inicial.length);
            $.ajax({
                url: 'consultar_alertas_arcos.htm',
                type: 'POST',
                cache: false,
                contentType: "application/x-www-form-urlencoded; charset=UTF-8;",
                dataType: "json",
                data: {fecha_inicial: fecha_inicial1,
                    fecha_final: fecha_final1,
                    warning: warning,
                    info: info,
                    danger: danger,
                    id_arco: id_arco,
                    Motocicleta: Motocicleta,
                    Carro: Carro,
                    Taxi: Taxi,
                    Camion: Camion,
                    Camioneta: Camioneta,
                    color: color},
                success: function (data) {
                    console.log("Aqui esta");
                    console.log(data);

                    var datos;
                    var fuente;
                    for (i in data) {
                        if (data[i].fuente == null) {
                            fuente = ''
                        } else {
                            fuente = data[i].fuente;
                        }
                        if (data[i].tipo_registro == '3') {
                            datos = datos + '<tr>' +
                                    '<td>' +
                                    '<i class="fas fa-times-circle"></i>' +
                                    '</td>' +
                                    '<td>' +
                                    '<p>2020/03/20 04:45:09</p>' +
                                    '<a href="">' + data[i].nombre_arco + '</a>' +
                                    '</td>' +
                                    '<td>' +
                                    data[i].placa +
                                    '</td>' +
                                    '<td>' +
                                    data[i].descripcion +
                                    '</td>' +
                                    '<td>' +
                                    fuente +
                                    '</td>' +
                                    '</tr>';
                        } else if (data[i].tipo_registro == '2') {
                            datos = datos + '<tr>' +
                                    '<td>' +
                                    '<i class="fas fa-exclamation-triangle"></i>' +
                                    '</td>' +
                                    '<td>' +
                                    '<p>2020/03/20 04:45:09</p>' +
                                    '<a href="">' + data[i].nombre_arco + '</a>' +
                                    '</td>' +
                                    '<td>' +
                                    data[i].placa +
                                    '</td>' +
                                    '<td>' +
                                    data[i].descripcion +
                                    '</td>' +
                                    '<td>' +
                                    fuente +
                                    '</td>' +
                                    '</tr>';
                        } else if (data[i].tipo_registro == '1') {
                            datos = datos + '<tr>' +
                                    '<td>' +
                                    '<i class="fas fa-info-circle"></i>' +
                                    '</td>' +
                                    '<td>' +
                                    '<p>2020/03/20 04:45:09</p>' +
                                    '<a href="">' + data[i].nombre_arco + '</a>' +
                                    '</td>' +
                                    '<td>' +
                                    data[i].placa +
                                    '</td>' +
                                    '<td>' +
                                    data[i].descripcion +
                                    '</td>' +
                                    '<td>' +
                                    fuente +
                                    '</td>' +
                                    '</tr>';
                        }
                    }
                    $("#tbAlertasVehiculos").html(datos);
                }, error: function (error) {
                    console.log("Aqui esta2");
                    console.log(error);
                }

            });

        });

        $('#PDF').click(function (evento) {
            evento.preventDefault();
            var fecha_inicial = $("#fecha_inicial").val();
            var fecha_final = $("#fecha_final").val();
            var warning = $("#filter-warning").is(':checked');
            var info = $("#filter-info").is(':checked');
            var danger = $("#filter-danger").is(':checked');
            var id_arco = $("#check_arco").val();
            var Motocicleta = $("#Motocicleta").is(':checked');
            var Carro = $("#Carro").is(':checked');
            var Taxi = $("#Taxi").is(':checked');
            var Camion = $("#Camion").is(':checked');
            var Camioneta = $("#Camioneta").is(':checked');
            var color = $("#check-color").val();


            var fecha_inicial1 = fecha_inicial.slice(0, 10) + ' ' + fecha_inicial.slice(11, 16);
            var fecha_final1 = fecha_final.slice(0, 10) + ' ' + fecha_final.slice(11, 16);


            $.ajax({
                url: 'consultar_alertas_arcos.htm',
                type: 'POST',
                cache: false,
                contentType: "application/x-www-form-urlencoded; charset=UTF-8;",
                dataType: "json",
                data: {fecha_inicial: fecha_inicial1,
                    fecha_final: fecha_final1,
                    warning: warning,
                    info: info,
                    danger: danger,
                    id_arco: id_arco,
                    Motocicleta: Motocicleta,
                    Carro: Carro,
                    Taxi: Taxi,
                    Camion: Camion,
                    Camioneta: Camioneta,
                    color: color},
                success: function (data) {
                    console.log("Aqui esta");
                    console.log(data);

                    var datos = '<div><tbody id="tbAlertasVehiculos">';
                    datos = datos + '<thead> <th>'
                    var fuente;
                    for (i in data) {
                        if (data[i].fuente == null) {
                            fuente = '';
                        } else {
                            fuente = data[i].fuente;
                        }
                        if (data[i].tipo_registro == '3') {
                            datos = datos + '<tr>' +
                                    '<td>' +
                                    '<i class="fas fa-times-circle"></i>' +
                                    '</td>' +
                                    '<td>' +
                                    '<p>' + data[i].fecha_hora + '</p>' +
                                    '<p>' + data[i].nombre_arco + '</p>' +
                                    '</td>' +
                                    '<td>' +
                                    data[i].placa +
                                    '</td>' +
                                    '<td>' +
                                    data[i].descripcion +
                                    '</td>' +
                                    '<td>' +
                                    fuente +
                                    '</td>' +
                                    '</tr>';
                            $("#tbDatosAlerta").html(datos);
                        } else if (data[i].tipo_registro == '2') {
                            datos = datos + '<tr>' +
                                    '<td>' +
                                    '<i class="fas fa-exclamation-triangle"></i>' +
                                    '</td>' +
                                    '<td>' +
                                    '<p>' + data[i].fecha_hora + '</p>' +
                                    '<p>' + data[i].nombre_arco + '</p>' +
                                    '</td>' +
                                    '<td>' +
                                    data[i].placa +
                                    '</td>' +
                                    '<td>' +
                                    data[i].descripcion +
                                    '</td>' +
                                    '<td>' +
                                    fuente +
                                    '</td>' +
                                    '</tr>';
                            $("#tbDatosAlerta").html(datos);
                        } else if (data[i].tipo_registro == '1') {
                            datos = datos + '<tr>' +
                                    '<td>' +
                                    '<i class="fas fa-info-circle"></i>' +
                                    '</td>' +
                                    '<td>' +
                                    '<p>' + data[i].fecha_hora + '</p>' +
                                    '<p>' + data[i].nombre_arco + '</p>' +
                                    '</td>' +
                                    '<td>' +
                                    data[i].placa +
                                    '</td>' +
                                    '<td>' +
                                    data[i].descripcion +
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
                    win.document.write('<title>Lecturas de arcos</title>');   // <title> FOR PDF HEADER.
                    win.document.write(style);
                    win.document.write('</head>');
                    win.document.write('<body>');
                    win.document.write('<br><br><img  src="images/logo-kiotrack-color.png" style="height: 33px; width: 239px;" alt="kiotrack-logo-login">');


                    win.document.write('<br><p><b>Arcos: </b></p>');
                    win.document.write('<div class="">');
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



                    var motoPDF;
                    if (Motocicleta == true) {
                        motoPDF = '<input id="Motocicleta" type="checkbox" class="fas fa-motorcycle check-icon" checked>';
                    } else {
                        motoPDF = '<input id="Motocicleta" type="checkbox" class="fas fa-motorcycle check-icon">';
                    }
                    var CarroPDF;
                    if (Carro == true) {
                        CarroPDF = '<input id="Carro" type="checkbox" class="fas fa-car check-icon" checked>';
                    } else {
                        CarroPDF = '<input id="Carro" type="checkbox" class="fas fa-car check-icon">';
                    }
                    var TaxiPDF;
                    if (Taxi == true) {
                        TaxiPDF = '<input id="Taxi" type="checkbox" class="fas fa-taxi check-icon" checked>';
                    } else {
                        TaxiPDF = '<input id="Taxi" type="checkbox" class="fas fa-taxi check-icon">';
                    }
                    var CamionPDF;
                    if (Camion == true) {
                        CamionPDF = '<input id="Camion" type="checkbox" class="fas fa-bus-alt check-icon" checked>';
                    } else {
                        CamionPDF = '<input id="Camion" type="checkbox" class="fas fa-bus-alt check-icon">';
                    }
                    var CamionetaPDF;
                    if (Camioneta == true) {
                        CamionetaPDF = '<input id="Camioneta" type="checkbox" class="fas fa-truck-pickup check-icon" checked>';
                    } else {
                        CamionetaPDF = '<input id="Camioneta" type="checkbox" class="fas fa-truck-pickup check-icon">';
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



                    var filtros = '<div class="">' +
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


                    var tipo_vehiculo = '<div class="container"><div class="row">' +
                            filtros +
                            '<div class="">' +
                            motoPDF +
                            CarroPDF +
                            TaxiPDF +
                            CamionPDF +
                            CamionetaPDF +
                            '</div></div></div><br>';


                    win.document.write(tipo_vehiculo);
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
            var fecha_inicial = $("#fecha_inicial").val();
            var fecha_final = $("#fecha_final").val();
            var warning = $("#filter-warning").is(':checked');
            var info = $("#filter-info").is(':checked');
            var danger = $("#filter-danger").is(':checked');
            var id_arco = $("#check_arco").val();
            var Motocicleta = $("#Motocicleta").is(':checked');
            var Carro = $("#Carro").is(':checked');
            var Taxi = $("#Taxi").is(':checked');
            var Camion = $("#Camion").is(':checked');
            var Camioneta = $("#Camioneta").is(':checked');
            var color = $("#check-color").val();


            var fecha_inicial1 = fecha_inicial.slice(0, 10) + ' ' + fecha_inicial.slice(11, 16);
            var fecha_final1 = fecha_final.slice(0, 10) + ' ' + fecha_final.slice(11, 16);


            $.ajax({
                url: 'consultar_alertas_arcos.htm',
                type: 'POST',
                cache: false,
                contentType: "application/x-www-form-urlencoded; charset=UTF-8;",
                dataType: "json",
                data: {fecha_inicial: fecha_inicial1,
                    fecha_final: fecha_final1,
                    warning: warning,
                    info: info,
                    danger: danger,
                    id_arco: id_arco,
                    Motocicleta: Motocicleta,
                    Carro: Carro,
                    Taxi: Taxi,
                    Camion: Camion,
                    Camioneta: Camioneta,
                    color: color},
                success: function (data) {
                    console.log("Aqui esta");
                    console.log(data);

                    var fuente;
                    var tipo;
                    var csv= 'Fecha inicial:,'+fecha_inicial1+', Fecha final: ,'+fecha_final1+'\n\n';
                    csv= csv+'Arcos,'+ id_arco + ', Color:,'+ color + '\n\n';
                    //csv= csv+ '1. Informativo\n2. Advertencia\n3. Critico\n\n';
                    csv= csv+ 'Tipo,Fecha y arco,Placa/Niv,Descripcion,Fuente de informacion\n';
                    
                    for (i in data) {
                        if (data[i].fuente == null) {
                            fuente = '';
                        } else {
                            fuente = data[i].fuente;
                        }
                        
                        if(data[i].tipo_registro == '1'){
                            tipo= 'Informativo';
                        }else if (data[i].tipo_registro == '2'){
                            tipo= 'Advertencia';
                        }else if(data[i].tipo_registro == '3'){
                            tipo= 'Critico';
                        }
                        csv = csv + tipo + ', ' + data[i].fecha_hora + ' ' + data[i].nombre_arco + ',' + data[i].placa + ','+ data[i].descripcion + ',' + fuente + '\n';
                    }
                    
                    var sTable = document.getElementById('tablaPDF').innerHTML;
                    
                    console.log(csv);
                    
                    var data = $("tablacsv").first(); //Only one table
                    var csvData = [];
                    var tmpArr = [];
                    var tmpStr = '';
                    data.find("tr").each(function() {
                        var th=$("tablacsv").find("th");
                        if(th.length) {
                            th.each(function() {
                              tmpStr = $(this).text().replace(/"/g, '""');
                              tmpArr.push('"' + tmpStr + '"');
                            });
                            csvData.push(tmpArr);
                        } else {
                            tmpArr = [];
                               $$("tablacsv").find("td").each(function() {
                                    if($(this).text().match(/^-{0,1}\d*\.{0,1}\d+$/)) {
                                        tmpArr.push(parseFloat($(this).text()));
                                    } else {
                                        tmpStr = $(this).text().replace(/"/g, '""');
                                        tmpArr.push('"' + tmpStr + '"');
                                    }
                               });
                            csvData.push(tmpArr.join(','));
                        }
                    });
                    console.log(csvData);
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