<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="sena.adso.config.DBConnection" %>
<%@ page import="sena.adso.config.ErrorManager" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Eliminar Producto - Panadería</title>
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
            .card {
                border-radius: 1rem;
                box-shadow: 0 4px 24px rgba(255, 179, 71, 0.15);
            }
            .btn-danger, .btn-secondary {
                border-radius: 2rem;
                font-weight: 600;
                letter-spacing: 0.5px;
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
            .btn-secondary {
                background: linear-gradient(90deg, #ffcc33 0%, #ffb347 100%);
                color: #7c4700;
                border: none;
            }
            .btn-secondary:hover {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #fff;
            }
            .form-label i, .card-title i {
                color: #ff7043;
                margin-right: 4px;
            }
            .card-header {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #7c4700;
                border-top-left-radius: 1rem;
                border-top-right-radius: 1rem;
            }
            .navbar-brand {
                font-family: 'Pacifico', cursive;
                font-size: 2rem;
                color: #7c4700 !important;
                letter-spacing: 1px;
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
        </style>
        <!-- Google Fonts para logo -->
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg mb-4">
            <div class="container">
                <a class="navbar-brand" href="../index.jsp">
                    <i class="fa-solid fa-bread-slice"></i> Panadería Gestión
                </a>
            </div>
        </nav>
        <div class="container mt-4">
            <div class="main-title">
                <i class="fa-solid fa-trash"></i> Eliminar Producto
            </div>
            <%
            Connection conn = null;
            PreparedStatement ps = null;
            PreparedStatement psCheck = null;
            ResultSet rsCheck = null;
            String mensaje = "";
            boolean exito = false;
            String nombreProducto = "";
            String codigo = "";
            String descripcion = "";
            String precio = "";
            String stock = "";
            String categoria = "";
            String fecha_registro = "";
            String hora_registro = "";
            boolean confirmado = "true".equals(request.getParameter("confirmado"));
            String idStr = request.getParameter("id");
            int id = 0;
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    id = Integer.parseInt(idStr);
                } catch (NumberFormatException e) {
                    mensaje = "ID inválido. Debe ser un número entero.";
                }
            } else {
                mensaje = "No se proporcionó un ID para eliminar.";
            }
            if (id > 0) {
                try {
                    conn = DBConnection.getConnection();
                    if (!confirmado) {
                        String queryCheck = "SELECT * FROM producto WHERE id = ?";
                        psCheck = conn.prepareStatement(queryCheck);
                        psCheck.setInt(1, id);
                        rsCheck = psCheck.executeQuery();
                        if (rsCheck.next()) {
                            nombreProducto = rsCheck.getString("nombre");
                            codigo = rsCheck.getString("codigo");
                            descripcion = rsCheck.getString("descripcion");
                            precio = rsCheck.getString("precio");
                            stock = rsCheck.getString("stock");
                            categoria = rsCheck.getString("categoria");
                            fecha_registro = rsCheck.getString("fecha_registro");
                            hora_registro = rsCheck.getString("hora_registro");
                        } else {
                            mensaje = "No se encontró ningún producto con el ID proporcionado.";
                        }
                        rsCheck.close();
                        psCheck.close();
                    } else {
                        String query = "DELETE FROM producto WHERE id = ?";
                        ps = conn.prepareStatement(query);
                        ps.setInt(1, id);
                        int resultado = ps.executeUpdate();
                        if (resultado > 0) {
                            mensaje = "Producto eliminado correctamente";
                            exito = true;
                        } else {
                            mensaje = "Error al eliminar el producto. Es posible que no exista.";
                        }
                    }
                } catch (SQLException e) {
                    mensaje = ErrorManager.getDatabaseErrorMessage(e);
                } finally {
                    try {
                        if (rsCheck != null) rsCheck.close();
                        if (psCheck != null) psCheck.close();
                        if (ps != null) ps.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
            %>
            <div class="card shadow-sm">
                <% if (!confirmado && id > 0 && !nombreProducto.isEmpty()) { %>
                    <div class="card-header bg-warning text-dark">
                        <h5 class="card-title mb-0">Confirmar Eliminación</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <strong>¡Atención!</strong> Está a punto de eliminar el siguiente producto:
                        </div>
                        <div class="row mb-3 mt-4">
                            <div class="col-md-6">
                                <p><strong><i class="fa-solid fa-bread-slice me-2"></i>Nombre:</strong> <%= nombreProducto %></p>
                                <p><strong><i class="fa-solid fa-credit-card me-2"></i>Código:</strong> <%= codigo %></p>
                                <p><strong><i class="fa-solid fa-info-circle me-2"></i>Descripción:</strong> <%= descripcion %></p>
                                <p><strong><i class="fa-solid fa-clock me-2"></i>Hora de registro:</strong> <%= hora_registro %></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong><i class="fa-solid fa-dollar-sign me-2"></i>Precio:</strong> <%= precio %></p>
                                <p><strong><i class="fa-solid fa-box me-2"></i>Stock:</strong> <%= stock %></p>
                                <p><strong><i class="fa-solid fa-tags me-2"></i>Categoría:</strong> <%= categoria %></p>
                                <p><strong><i class="fa-solid fa-calendar-day me-2"></i>Fecha de registro:</strong> <%= fecha_registro %></p>
                            </div>
                        </div>
                        <div class="alert alert-danger">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            Esta acción no se puede deshacer. Una vez eliminado, no podrá recuperar esta información.
                        </div>
                        <div class="d-flex justify-content-between mt-4">
                            <a href="../index.jsp" class="btn btn-secondary">
                                <i class="fa-solid fa-xmark"></i> Cancelar
                            </a>
                            <a href="delete.jsp?id=<%= id %>&confirmado=true" class="btn btn-danger">
                                <i class="fa-solid fa-trash"></i> Confirmar Eliminación
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="card-header <%= exito ? "bg-success text-white" : "bg-danger text-white" %>">
                        <h5 class="card-title mb-0"><%= exito ? "Eliminación Exitosa" : "Error en la Operación" %></h5>
                    </div>
                    <div class="card-body">
                        <div class="alert <%= exito ? "alert-success" : "alert-danger" %>">
                            <i class="bi <%= exito ? "bi-check-circle-fill" : "bi-exclamation-triangle-fill" %> me-2"></i>
                            <%= mensaje %>
                        </div>
                        <div class="text-center mt-3">
                            <a href="../index.jsp" class="btn btn-primary">
                                <i class="bi bi-arrow-left me-1"></i>Volver al listado
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        <% if (confirmado && !mensaje.isEmpty()) { %>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                Swal.fire({
                    icon: '<%= exito ? "success" : "error" %>',
                    title: '<%= exito ? "¡Éxito!" : "Error" %>',
                    text: '<%= mensaje %>',
                    confirmButtonText: 'OK',
                }).then((result) => {
                    if ('<%= exito ? "true" : "false" %>' === 'true') {
                        window.location.href = '../index.jsp';
                    }
                });
                if ('<%= exito ? "true" : "false" %>' === 'true') {
                    setTimeout(function(){ window.location.href = '../index.jsp'; }, 2000);
                }
            </script>
        <% } %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
