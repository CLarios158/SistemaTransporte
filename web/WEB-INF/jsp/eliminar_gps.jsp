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
        <link href="https://cdn.jsdelivr.net/gh/gitbrent/bootstrap4-toggle@3.6.1/css/bootstrap4-toggle.min.css" rel="stylesheet">

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

                            <%
                                try {
                                    ResultSet r = Conexion.query("select * from sp_advertencias_promedio()");
                                    while (r.next()) {
                                        if (r.getString(1).equals("Critico")) {%>

                            <div class="display-chart">
                                <div class="dc-info">
                                    <i class="dc-icon dc-danger"></i>
                                    <div class="dc-info-content">
                                        <span class="dc-info-top"><%= r.getString(2)%>%</span>
                                        <span class="dc-info-msg"><%= r.getString(1)%></span>
                                    </div>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar" role="progressbar" style="width: <%= r.getString(2)%>%"></div>
                                </div>
                            </div>

                            <%
                            } else if (r.getString(1).equals("Advertencia")) {%>


                            <div class="display-chart">
                                <div class="dc-info">
                                    <i class="dc-icon dc-warning"></i>
                                    <div class="dc-info-content">
                                        <span class="dc-info-top"><%= r.getString(2)%>%</span>
                                        <span class="dc-info-msg"><%= r.getString(1)%></span>
                                    </div>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar" role="progressbar" style="width: <%= r.getString(2)%>%"></div>
                                </div>
                            </div>

                            <%
                            } else if (r.getString(1).equals("Informativo")) {%>

                            <div class="display-chart">
                                <div class="dc-info">
                                    <i class="dc-icon dc-info"></i>
                                    <div class="dc-info-content">
                                        <span class="dc-info-top"><%= r.getString(2)%>%</span>
                                        <span class="dc-info-msg"><%= r.getString(1)%></span>
                                    </div>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar" role="progressbar" style="width: <%= r.getString(2)%>%"></div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <%
                                }
                            }
                            r.close();
                        } catch (Exception e) {
                        }
                    %>        


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
            <div class="row" style="margin: 0px;">
                <div class="col">
                    <nav class="nav nav-horizontal flex-row">
                        <a class="color-label" href="index.htm"><i class="fas fa-home color-icon"></i>GPS |</a>
                        <a class="color-label-bold" href="asociar_gps.htm" >Gestión de GPS</a>
                    </nav>
                </div>
            </div>
            <div class="line"></div>
            <div class="row" style="margin: 20px 0px 20px 0px;">
                <div class="col center">
                    <label class="text-white">Eliminar Información de Rastreo</label>
                </div>
            </div>
            <form name="myForm" onsubmit="return(validate());">
                <div class="form-group center">
                    <div class="col-sm-2">
                        <label style="font-size: 13px;" class="text-white">Buscar NIV:</label>
                    </div>
                    <div class="col-sm-2">
                        <i class="fas fa-search icon-input"></i>
                        <input type="text" class="form-control" name="buscarNIV" id="buscarNIV" autocomplete="off">
                        <div style="z-index: 2; position: absolute; width: 87%;"  class="list-group" id="show-list"></div>
                    </div>

                </div>
            </form>
            <div class="form-group center">
                <div class="col-sm-2">
                    <label style="font-size: 13px;" class="text-white">Número de Serie GPS:</label>
                </div>
                <div class="col-sm-2">
                    <label style="font-size: 13px;" class="text-white" id="lblno_serie"/>
                </div>
            </div>
            <div class="form-group center">
                <div class="col-sm-2">
                    <label style="font-size: 13px;" class="text-white">Modelo de GPS:</label>
                </div>
                <div class="col-sm-2">
                    <label style="font-size: 13px;" class="text-white" id="lblmodelo_gps"></label>
                </div>
            </div> 
            <div class="form-group center">
                <div class="col-sm-2">
                    <label style="font-size: 13px;" class="text-white">Kilometraje:</label>
                </div>
                <div class="col-sm-2">
                    <label style="font-size: 13px;" class="text-white" id="lblkilometraje"></label>
                </div>
            </div>
            <div class="form-group">
                <div class="col center">
                    <button class="btn btn-primary" data-toggle="modal" data-target="#eliminarRastreo"> Eliminar</button>
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
        
        <!-- Modal Eliminar GPS-->
        <div class="modal fade" id="eliminarRastreo" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="false">
            <div class="modal-dialog" role="document">
                <div style="color: #05151C;" class="modal-content">
                    <div class="modal-body">                      
                        <div class="form-group">
                            <div class="col center"><i style="color: #c82333;" class="fas fa-exclamation-triangle fa-2x"></i></div>
                        </div>
                        <div class="form-group">
                            <div class="col center"><h5 class="text-white">Eliminar Información de Rastreo</h5></div>
                        </div>
                        <div class="separator center"></div>
                        <div class="row">
                            <div class="col center"><p style="font-size: 12px;" >Si elimina la información se perderá la información de rastreo de la unidad.</p></div>
                        </div>
                        <div class="row">
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 12px;">¿Desea eliminar la información de rastreo?</p></div>
                        </div>                        
                        <input type="text" hidden id="id_unidad" name="id_unidad" />
                        <input type="text" hidden id="id_gps" name="id_gps" />
                        <div class="form-group center">
                            <button class="btn btn-primary" data-dismiss="modal">Cancelar</button>
                            <button id="eliminar" class="btn btn-outline-primary" data-dismiss="modal">Aceptar</button>
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
                            <div class="col center"><p style="color: #f8e71c; font-weight: bold; font-size: 12px;">Se ha eliminado la información del GPS</p></div>
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
        <script src="https://cdn.jsdelivr.net/gh/gitbrent/bootstrap4-toggle@3.6.1/js/bootstrap4-toggle.min.js"></script>
        <script src="javascript/vendors/popper.min.js"></script>
        <script src="javascript/vendors/bootstrap.min.js"></script>
        <script src="javascript/slide_menu.js"></script>
        <script src="javascript/main.js"></script>

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
        
        <!-- Buscar NIV -->
        <script type="text/javascript">
            
            $(document).ready(function () {
                $("#buscarNIV").keyup(function(e){
                   e.preventDefault();
                   var niv = $(this).val();
                   if(niv !== ''){
                       $.ajax({
                            url: 'buscar_gps.htm',
                            type: "POST",
                            dataType: 'json',
                            data: { niv: niv }, 
                        success: function (data) {
                            if(data.length > 0){
                                var lista = "";
                                for (i in data) {
                                    lista += '<a id="click-unidad" href="#" data-id="'+data[i].id_unidad+'" class="list-group-item list-group-item-action border-1">'+data[i].niv+'</a>';
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
                
                $(document).on('click','a[id="click-unidad"]', function(e){                   
                    e.preventDefault();
                    $("#buscarNIV").val($(this).text());
                    $.ajax({
                            url: 'obtener_datos_gps.htm',
                            type: "POST",
                            dataType: 'json',
                            data: { niv: $(this).text() }, 
                        success: function (data) {
                            
                            document.getElementById("lblno_serie").innerHTML = data.no_serie_gps;
                            document.getElementById("lblmodelo_gps").innerHTML = data.nombre;
                            document.getElementById("lblkilometraje").innerHTML = data.kilometraje;
                            $("#id_gps").val(data.id_gps);
                            $("#id_unidad").val(data.id_unidad);
                        }
                    });
                    $("#show-list").html('');
                });
                
            });
        </script>
        
         <!-- Eliminar Informacion GPS -->
        <script type="text/javascript">
            $('#eliminar').click(function (e) {
                e.preventDefault();
                
                var id_gps = $("#id_gps").val();
                var id_unidad = $("#id_unidad").val();
                
                $.ajax({
                    url: 'eliminar_informacion_gps.htm',
                    method : 'POST',
                    dataType: 'json',
                    data: {
                        id_gps: id_gps,
                        id_unidad : id_unidad
                    }, 
                success: function (data) {
                    if(data.estado === 1){
                        $('#modalExito').modal('show');
                        $('#modalExito').on('hidden.bs.modal', function () {
                            location.reload();
                        });
                    }
                },error:  function(){
                    alert("entro");
                }});  
            });
        </script>

    </body>

</html>

