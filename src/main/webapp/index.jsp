<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sena.adso.config.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
    String buscar = request.getParameter("buscar");
    String campo = request.getParameter("campo");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Gestión de Productos - Panadería</title>
        <!-- Bootstrap CSS para estilos -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons para iconos -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
        <!-- FontAwesome para más iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #fffbe6 0%, #ffe5b4 100%);
                min-height: 100vh;
            }
            .navbar {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }
            .main-title {
                color: #7c4700;
                font-family: 'Pacifico', cursive;
                font-size: 2.5rem;
                text-align: center;
                margin-top: 1.5rem;
                margin-bottom: 2rem;
                text-shadow: 1px 2px 8px #ffe5b4;
                letter-spacing: 1px;
            }
            .search-section {
                background: #fffbe6;
                border-radius: 1rem;
                box-shadow: 0 2px 12px rgba(255, 179, 71, 0.10);
                padding: 1.5rem 2rem 1rem 2rem;
                margin-bottom: 2rem;
            }
            .search-section input, .search-section select {
                border-radius: 1.5rem;
                border: 1px solid #ffb347;
                padding-left: 1.2rem;
            }
            .search-section .btn-info {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #7c4700;
                border: none;
                border-radius: 2rem;
                font-weight: 600;
                letter-spacing: 0.5px;
                box-shadow: 0 2px 8px rgba(255, 179, 71, 0.10);
            }
            .search-section .btn-info:hover {
                background: linear-gradient(90deg, #ffcc33 0%, #ffb347 100%);
                color: #fff;
            }
            .card {
                border-radius: 1rem;
                box-shadow: 0 4px 24px rgba(255, 179, 71, 0.15);
            }
            .table {
                border-radius: 1rem;
                overflow: hidden;
            }
            .table thead {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .table th {
                font-size: 1.1rem;
                color: #7c4700;
                letter-spacing: 0.5px;
            }
            .table th i, .table td i {
                color: #ff7043;
                margin-right: 8px;
            }
            .table-striped>tbody>tr:nth-of-type(odd) {
                background-color: #fff8e1;
            }
            .table-striped>tbody>tr:nth-of-type(even) {
                background-color: #ffe5b4;
            }
            .btn-success, .btn-warning, .btn-danger, .btn-primary {
                border-radius: 2rem;
                font-weight: 600;
                letter-spacing: 0.5px;
            }
            .btn-success {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #7c4700;
                border: none;
            }
            .btn-success:hover {
                background: linear-gradient(90deg, #ffcc33 0%, #ffb347 100%);
                color: #fff;
            }
            .btn-warning {
                background: linear-gradient(90deg, #ffcc33 0%, #ffb347 100%);
                color: #7c4700;
                border: none;
            }
            .btn-warning:hover {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #fff;
            }
            .btn-danger {
                background: linear-gradient(90deg, #ff7043 0%, #ffb347 100%);
                color: #fff;
                border: none;
            }
            .btn-danger:hover {
                background: linear-gradient(90deg, #ffb347 0%, #ff7043 100%);
                color: #fff;
            }
            .btn-primary {
                background: linear-gradient(90deg, #7c4700 0%, #ffb347 100%);
                color: #fff;
                border: none;
            }
            .btn-primary:hover {
                background: linear-gradient(90deg, #ffb347 0%, #7c4700 100%);
                color: #fff;
            }
            .card-header {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #7c4700;
                border-top-left-radius: 1rem;
                border-top-right-radius: 1rem;
            }
            .card-title i {
                color: #ff7043;
            }
            .navbar-brand {
                font-family: 'Pacifico', cursive;
                font-size: 2rem;
                color: #7c4700 !important;
                letter-spacing: 1px;
            }
            /* Modal personalizado para eliminar */
            #modalEliminar .modal-content {
                border-radius: 1.2rem;
                box-shadow: 0 4px 24px rgba(255, 179, 71, 0.18);
            }
            #modalEliminar .modal-header {
                background: linear-gradient(90deg, #ffb347 0%, #ff7043 100%);
                color: #7c4700;
                border-top-left-radius: 1.2rem;
                border-top-right-radius: 1.2rem;
                border-bottom: none;
            }
            #modalEliminar .modal-title {
                font-family: 'Pacifico', cursive;
                font-size: 1.5rem;
                color: #7c4700;
            }
            #modalEliminar .btn-cancelar {
                background: linear-gradient(90deg, #fffbe6 0%, #ffe5b4 100%);
                color: #7c4700;
                border: none;
                border-radius: 2rem;
                font-weight: 600;
                padding: 0.5rem 1.5rem;
            }
            #modalEliminar .btn-cancelar:hover {
                background: linear-gradient(90deg, #ffe5b4 0%, #fffbe6 100%);
                color: #ff7043;
            }
            #modalEliminar .btn-eliminar {
                background: linear-gradient(90deg, #ff7043 0%, #ffb347 100%);
                color: #fff;
                border: none;
                border-radius: 2rem;
                font-weight: 600;
                padding: 0.5rem 1.5rem;
            }
            #modalEliminar .btn-eliminar:hover {
                background: linear-gradient(90deg, #ffb347 0%, #ff7043 100%);
                color: #fff;
            }
            .btn-accion-editar {
                background: linear-gradient(90deg, #ffcc33 0%, #ffb347 100%);
                color: #7c4700;
                border: none;
                border-radius: 2rem;
                font-weight: bold;
                font-size: 1rem;
                padding: 0.4rem 1.2rem;
                margin-bottom: 0.4rem;
                box-shadow: 0 2px 8px rgba(255, 179, 71, 0.15);
                display: flex;
                align-items: center;
                gap: 0.6rem;
            }
            .btn-accion-editar i {
                font-size: 1.1rem;
            }
            .btn-accion-editar:hover {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #fff;
            }
            .btn-accion-eliminar {
                background: linear-gradient(90deg, #ff7043 0%, #ffb347 100%);
                color: #fff;
                border: none;
                border-radius: 2rem;
                font-weight: bold;
                font-size: 1rem;
                padding: 0.4rem 1.2rem;
                box-shadow: 0 2px 8px rgba(255, 112, 67, 0.15);
                display: flex;
                align-items: center;
                gap: 0.6rem;
            }
            .btn-accion-eliminar i {
                font-size: 1.1rem;
            }
            .btn-accion-eliminar:hover {
                background: linear-gradient(90deg, #ffb347 0%, #ff7043 100%);
                color: #fff;
            }
        </style>
        <!-- Google Fonts para logo -->
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg mb-4">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">
                    <i class="fa-solid fa-bread-slice"></i> Panadería Gestión
                </a>
            </div>
        </nav>
        <div class="container">
            <div class="main-title">
                <i class="fa-solid fa-bread-slice"></i> Gestión de Productos de Panadería
            </div>
            <div class="search-section mb-4">
                <div class="row mb-3 align-items-center">
                    <div class="col-md-8">
                        <form action="index.jsp" method="GET" class="row g-3">
                            <div class="col-md-5">
                                <input type="text" name="buscar" class="form-control" 
                                       placeholder="Buscar..." 
                                       value="<%= buscar != null ? buscar : ""%>">
                            </div>
                            <div class="col-md-4">
                                <select name="campo" class="form-control">
                                    <option value="todos" <%= campo == null || campo.equals("todos") ? "selected" : ""%>>Todos los campos</option>
                                    <option value="codigo" <%= campo != null && campo.equals("codigo") ? "selected" : ""%>>Codigo</option>
                                    <option value="nombre" <%= campo != null && campo.equals("nombre") ? "selected" : ""%>>Nombre</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-info w-100">
                                    <i class="bi bi-search"></i> Buscar
                                </button>
                            </div>
                        </form>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="views/add.jsp" class="btn btn-success">
                            <i class="bi bi-plus-circle"></i> Agregar Producto
                        </a>
                    </div>
                </div>
            </div>
            <%
                // Definición de variables globales (accesibles en toda la página)
                int registrosPorPagina = 5; // Número de registros por página
                int paginaActual = 1; // Página por defecto

                // Obtener la página solicitada si existe
                String paginaParam = request.getParameter("pagina");
                if (paginaParam != null && !paginaParam.isEmpty()) {
                    try {
                        paginaActual = Integer.parseInt(paginaParam);
                        if (paginaActual < 1) {
                            paginaActual = 1;
                        }
                    } catch (NumberFormatException e) {
                        // Si hay error de formato, permanece en página 1
                        paginaActual = 1;
                    }
                }

                // Calcular el offset para la consulta SQL
                int offset = (paginaActual - 1) * registrosPorPagina;

                // Contador de registros totales (para calcular el número de páginas)
                int totalRegistros = 0;
            %>
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light">
                    <h5 class="card-title mb-0">Listado de Productos</h5>
                </div>
                <div class="card-body table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-light">
                            <tr>
                                <th><i class="fa-solid fa-hashtag" style="margin-right:8px;"></i> Id</th>
                                <th><i class="fa-solid fa-barcode" style="margin-right:8px;"></i> Código</th>
                                <th><i class="fa-solid fa-bread-slice" style="margin-right:8px;"></i> Nombre</th>
                                <th><i class="fa-solid fa-align-left" style="margin-right:8px;"></i> Descripción</th>
                                <th><i class="fa-solid fa-dollar-sign" style="margin-right:8px;"></i> Precio</th>
                                <th><i class="fa-solid fa-box" style="margin-right:8px;"></i> Stock</th>
                                <th><i class="fa-solid fa-tags" style="margin-right:8px;"></i> Categoría</th>
                                <th><i class="fa-solid fa-calendar-day" style="margin-right:8px;"></i> Fecha de Registro</th>
                                <th><i class="fa-solid fa-clock" style="margin-right:8px;"></i> Hora de Registro</th>
                                <th><i class="fa-solid fa-gear" style="margin-right:8px;"></i> Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Declaración de variables para la conexión a la base de datos
                                Connection conn = null;
                                PreparedStatement ps = null;
                                ResultSet rs = null;
                                PreparedStatement psCount = null;
                                ResultSet rsCount = null;

                                try {
                                    // Obtener la conexión a la base de datos
                                    conn = DBConnection.getConnection();

                                    // Construir la consulta SQL basada en los parámetros de búsqueda
                                    // Consulta SQL para contar el total de registros (para la paginación)
                                    String queryCount;
                                    // Consulta SQL para obtener los registros de la página actual
                                    String query;

                                    // Si hay criterios de búsqueda, filtrar los resultados
                                    if (buscar != null && !buscar.isEmpty()) {
                                        // Construir la consulta según el campo seleccionado
                                        if (campo != null && campo.equals("codigo")) {
                                            queryCount = "SELECT COUNT(*) FROM producto WHERE codigo LIKE ?";
                                            query = "SELECT * FROM producto WHERE codigo LIKE ? LIMIT ? OFFSET ?";

                                            // Preparar la consulta COUNT
                                            psCount = conn.prepareStatement(queryCount);
                                            psCount.setString(1, "%" + buscar + "%");

                                            // Preparar la consulta SELECT
                                            ps = conn.prepareStatement(query);
                                            ps.setString(1, "%" + buscar + "%");
                                            ps.setInt(2, registrosPorPagina);
                                            ps.setInt(3, offset);
                                        } else if (campo != null && campo.equals("nombre")) {
                                            queryCount = "SELECT COUNT(*) FROM producto WHERE nombre LIKE ?";
                                            query = "SELECT * FROM producto WHERE nombre LIKE ? LIMIT ? OFFSET ?";

                                            // Preparar la consulta COUNT
                                            psCount = conn.prepareStatement(queryCount);
                                            psCount.setString(1, "%" + buscar + "%");

                                            // Preparar la consulta SELECT
                                            ps = conn.prepareStatement(query);
                                            ps.setString(1, "%" + buscar + "%");
                                            ps.setInt(2, registrosPorPagina);
                                            ps.setInt(3, offset);
                                        } else {
                                            // Búsqueda en todos los campos
                                            queryCount = "SELECT COUNT(*) FROM producto WHERE nombre LIKE ? OR codigo LIKE ?";
                                            query = "SELECT * FROM producto WHERE nombre LIKE ? OR codigo LIKE ? LIMIT ? OFFSET ?";

                                            // Preparar la consulta COUNT
                                            psCount = conn.prepareStatement(queryCount);
                                            psCount.setString(1, "%" + buscar + "%");
                                            psCount.setString(2, "%" + buscar + "%");

                                            // Preparar la consulta SELECT
                                            ps = conn.prepareStatement(query);
                                            ps.setString(1, "%" + buscar + "%");
                                            ps.setString(2, "%" + buscar + "%");
                                            ps.setInt(3, registrosPorPagina);
                                            ps.setInt(4, offset);
                                        }
                                    } else {
                                        // Sin filtros, mostrar todos los registros paginados
                                        queryCount = "SELECT COUNT(*) FROM producto";
                                        query = "SELECT * FROM producto LIMIT ? OFFSET ?";

                                        // Preparar la consulta COUNT
                                        psCount = conn.prepareStatement(queryCount);

                                        // Preparar la consulta SELECT
                                        ps = conn.prepareStatement(query);
                                        ps.setInt(1, registrosPorPagina);
                                        ps.setInt(2, offset);
                                    }

                                    // Ejecutar consulta de conteo
                                    rsCount = psCount.executeQuery();
                                    if (rsCount.next()) {
                                        totalRegistros = rsCount.getInt(1);
                                    }

                                    // Ejecutar consulta de datos
                                    rs = ps.executeQuery();

                                    // Verificar si hay registros para mostrar
                                    boolean hayRegistros = false;

                                    // Mostrar resultados en la tabla
                                    while (rs.next()) {
                                        hayRegistros = true;
                            %>
                            <tr>
                                <td><%= rs.getInt("id")%></td>
                                <td><%= rs.getString("codigo")%></td>
                                <td><%= rs.getString("nombre")%></td>
                                <td><%= rs.getString("descripcion")%></td>
                                <td><%= rs.getString("precio")%></td>
                                <td><%= rs.getInt("stock")%></td>
                                <td><%= rs.getString("categoria")%></td>
                                <td><%= rs.getString("fecha_registro")%></td>
                                <td><%= rs.getString("hora_registro")%></td>
                                <td>
                                    <%-- Botones de acción para cada registro --%>
                                    <a href="views/edit.jsp?id=<%= rs.getInt("id")%>" class="btn btn-accion-editar mb-2">
                                        <i class="fa-solid fa-pen-to-square"></i> Editar
                                    </a>
                                    <a href="#" class="btn btn-accion-eliminar" data-id="<%= rs.getInt("id")%>" onclick="return confirmarEliminar(this);">
                                        <i class="fa-solid fa-trash"></i> Eliminar
                                    </a>
                                </td>
                            </tr>
                            <%
                                }

                                // Mostrar mensaje si no hay registros
                                if (!hayRegistros) {
                            %>
                            <tr>
                                <td colspan="4" class="text-center py-3">
                                    <div class="alert alert-info mb-0">
                                        <i class="bi bi-info-circle me-2"></i> No se encontraron registros
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    // Mostrar mensaje de error si hay problemas con la base de datos
                                    out.println("<tr><td colspan='4' class='text-center'>");
                                    out.println("<div class='alert alert-danger'>");
                                    out.println("<i class='bi bi-exclamation-triangle me-2'></i>");
                                    out.println("Error: " + e.getMessage());
                                    out.println("</div>");
                                    out.println("</td></tr>");
                                } finally {
                                    // Cerrar todos los recursos de conexión
                                    try {
                                        if (rsCount != null) {
                                            rsCount.close();
                                        }
                                        if (psCount != null) {
                                            psCount.close();
                                        }
                                        if (rs != null) {
                                            rs.close();
                                        }
                                        if (ps != null) {
                                            ps.close();
                                        }
                                        // No cerramos la conexión aquí para reutilizarla
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <%-- Paginación --%>
                <div class="card-footer">
                    <%
                        // Calcular el número total de páginas
                        int totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);

                        // Mostrar la paginación solo si hay más de una página
                        if (totalPaginas > 1) {
                    %>
                    <nav aria-label="Navegación de páginas">
                        <ul class="pagination justify-content-center mb-0">
                            <%-- Botón para ir a la primera página --%>
                            <li class="page-item <%= paginaActual == 1 ? "disabled" : ""%>">
                                <a class="page-link" href="index.jsp?pagina=1<%= buscar != null && !buscar.isEmpty() ? "&buscar=" + buscar : ""%><%= campo != null ? "&campo=" + campo : ""%>">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>

                            <%-- Botón para ir a la página anterior --%>
                            <li class="page-item <%= paginaActual == 1 ? "disabled" : ""%>">
                                <a class="page-link" href="index.jsp?pagina=<%= paginaActual - 1%><%= buscar != null && !buscar.isEmpty() ? "&buscar=" + buscar : ""%><%= campo != null ? "&campo=" + campo : ""%>">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>

                            <%-- Mostrar enlaces a páginas cercanas a la actual --%>
                            <%
                                // Determinar el rango de páginas a mostrar
                                int inicio = Math.max(1, paginaActual - 2);
                                int fin = Math.min(totalPaginas, paginaActual + 2);

                                // Asegurar que se muestren al menos 5 páginas si hay suficientes
                                if (fin - inicio + 1 < 5 && totalPaginas >= 5) {
                                    if (inicio == 1) {
                                        fin = Math.min(totalPaginas, 5);
                                    } else if (fin == totalPaginas) {
                                        inicio = Math.max(1, totalPaginas - 4);
                                    }
                                }

                                // Mostrar enlaces a páginas
                                for (int i = inicio; i <= fin; i++) {
                            %>
                            <li class="page-item <%= i == paginaActual ? "active" : ""%>">
                                <a class="page-link" href="index.jsp?pagina=<%= i%><%= buscar != null && !buscar.isEmpty() ? "&buscar=" + buscar : ""%><%= campo != null ? "&campo=" + campo : ""%>">
                                    <%= i%>
                                </a>
                            </li>
                            <% }%>

                            <%-- Botón para ir a la página siguiente --%>
                            <li class="page-item <%= paginaActual == totalPaginas ? "disabled" : ""%>">
                                <a class="page-link" href="index.jsp?pagina=<%= paginaActual + 1%><%= buscar != null && !buscar.isEmpty() ? "&buscar=" + buscar : ""%><%= campo != null ? "&campo=" + campo : ""%>">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>

                            <%-- Botón para ir a la última página --%>
                            <li class="page-item <%= paginaActual == totalPaginas ? "disabled" : ""%>">
                                <a class="page-link" href="index.jsp?pagina=<%= totalPaginas%><%= buscar != null && !buscar.isEmpty() ? "&buscar=" + buscar : ""%><%= campo != null ? "&campo=" + campo : ""%>">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                    <% }%>
                </div>
            </div>
        </div>
        <%-- Modal de confirmación para eliminar --%>
        <div class="modal fade" id="modalEliminar" tabindex="-1" aria-labelledby="modalEliminarLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalEliminarLabel">
                            <i class="fa-solid fa-trash me-2"></i>Eliminar el producto
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        ¿Está seguro que desea eliminar este registro? Esta acción no se puede deshacer.
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-cancelar" data-bs-dismiss="modal">Cancelar</button>
                        <a href="#" id="btnEliminar" class="btn btn-eliminar">Eliminar</a>
                    </div>
                </div>
            </div>
        </div>
        
    <%-- Scripts JavaScript --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para confirmar la eliminación de un registro mediante un modal
        function confirmarEliminar(element) {
            // Obtener el ID del atributo data-id
            var id = element.getAttribute('data-id');
            
            // Configurar el enlace del botón de eliminar
            document.getElementById('btnEliminar').href = 'views/delete.jsp?id=' + id;
            
            // Mostrar el modal de confirmación
            var modal = new bootstrap.Modal(document.getElementById('modalEliminar'));
            modal.show();
            
            // Evitar que el enlace continúe con su acción predeterminada
            return false;
        }
    </script>
    </body>
</html>
